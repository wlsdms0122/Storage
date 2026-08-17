//
//  OverridingDBStorage.swift
//
//
//  Created by jsilver on 8/17/26.
//

import Foundation
@testable import Storage

/// A storage that answers `execute` itself instead of taking the default — the
/// shape a storage needs when running a transaction has to do more than the
/// protocol's own answer does. Everything else is the plain storage, so the two
/// doubles cannot drift apart.
final class OverridingDBStorage<Connection: Sendable>: DBStorable {
    // MARK: - Property
    private let base: ProxyDBStorage<Connection>

    private let _execute: @Sendable () -> Void
    private let _hook: @Sendable (String) -> Void

    // MARK: - Initializer
    init(
        connect: @escaping @Sendable () throws -> Connection,
        execute: @escaping @Sendable () -> Void = { },
        hook: @escaping @Sendable (String) -> Void = { _ in }
    ) {
        self.base = ProxyDBStorage(connect: connect)
        self._execute = execute
        self._hook = hook
    }

    // MARK: - Lifecycle
    func connect() throws -> Connection {
        try base.connect()
    }

    func migrate(connection: Connection) async throws {
        try await base.migrate(connection: connection)
    }

    func reset() async throws {
        try await base.reset()
    }

    func execute<T: DBTransaction>(_ transaction: T, on connection: Connection) async throws -> T.Result where T.Connection == Connection {
        _execute()

        return try await transaction.execute(connection)
    }

    func storage<T: DBTransaction>(_ storage: OverridingDBStorage, willRun transaction: T) where T.Connection == Connection {
        _hook("willRun")
    }

    func storage<T: DBTransaction>(_ storage: OverridingDBStorage, didRun transaction: T, withResult result: Result<T.Result, any Error>) where T.Connection == Connection {
        _hook("didRun")
    }
}
