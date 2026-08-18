//
//  DBStorable.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation

public protocol DBStorable<Connection, Transaction>: Sendable {
    associatedtype Connection
    /// The open transaction this storage hands out — the commit boundary that
    /// operations run inside.
    associatedtype Transaction

    func connect() async throws -> Connection
    func migrate(connection: Connection) async throws

    func reset() async throws

    /// Opens one transaction and hands it to the body. Everything the body does
    /// commits together or not at all — there is no default, because only the
    /// storage knows how its database begins and commits one.
    ///
    /// This is what a storage answers. What a caller reaches for is `run`, which
    /// is defined in terms of this and is where the hooks below are called; a
    /// caller that opened its own transaction would leave them out.
    ///
    /// The body is synchronous: a transaction is a serialized session, and the
    /// databases this abstracts hand out a handle valid only inside such a
    /// block. Waiting for the transaction is the caller's, and stays async.
    ///
    /// `readOnly` is what the caller's operation declared, passed on so the
    /// storage can open a cheaper transaction for it — skip the write lock, take
    /// a reader from the pool, route to a replica. A database that does not
    /// distinguish the two ignores it, in the open.
    func open<T>(readOnly: Bool, _ body: @escaping @Sendable (Transaction) throws -> T) async throws -> T

    func storage<T: DBOperation>(_ storage: Self, willRun operation: T) where T.Transaction == Transaction
    func storage<T: DBOperation>(_ storage: Self, didRun operation: T, withResult result: Result<T.Result, any Error>) where T.Transaction == Transaction
}

public extension DBStorable {
    func initialize() async throws {
        try await migrate(connection: try await connect())
    }

    /// An operation on its own — a transaction holding exactly this one, of the
    /// kind the operation asked for.
    @discardableResult
    func run<T: DBOperation>(_ operation: T) async throws -> T.Result where T.Transaction == Transaction {
        try await run(operation, readOnly: operation.readOnly)
    }

    func storage<T: DBOperation>(_ storage: Self, willRun operation: T) where T.Transaction == Transaction {

    }

    func storage<T: DBOperation>(_ storage: Self, didRun operation: T, withResult result: Result<T.Result, any Error>) where T.Transaction == Transaction {

    }
}

private extension DBStorable {
    /// The one path an operation runs through, whichever kind of transaction it
    /// asked for — so the hooks are called once, here, and cannot be skipped by
    /// picking the other one.
    func run<T: DBOperation>(
        _ operation: T,
        readOnly: Bool
    ) async throws -> T.Result where T.Transaction == Transaction {
        storage(self, willRun: operation)
        do {
            let result = try await open(readOnly: readOnly) { transaction in
                try operation.execute(transaction)
            }
            storage(self, didRun: operation, withResult: .success(result))

            return result
        } catch {
            storage(self, didRun: operation, withResult: .failure(error))
            throw error
        }
    }
}
