//
//  DB.swift
//
//
//  Created by jsilver on 8/18/26.
//

import Foundation

/// A database, once it is ready to be used.
///
/// It owns a store and offers only `run`, which is the access control a
/// protocol cannot give: a requirement is public by nature, so what decides
/// whether a caller can connect or migrate is not whether those are hidden but
/// what the reference in its hands offers. The driver stays in here.
///
/// It follows that there is no uninitialized `DB` — `connect` is the only way
/// to get one, and it does not return until the driver says the database is
/// ready. Which engine is inside is known at that one call and nowhere else.
public struct DB<Transaction>: Sendable {
    // MARK: - Property
    private let storage: any DBStorable<Transaction>

    // MARK: - Initializer
    private init(_ storage: any DBStorable<Transaction>) {
        self.storage = storage
    }

    // MARK: - Public
    public static func connect<D: DBDriver & DBStorable<Transaction>>(_ driver: D) async throws -> DB {
        try await driver.initialize()

        return DB(driver)
    }

    /// An operation on its own — a transaction holding exactly this one, of the
    /// kind the operation asked for.
    @discardableResult
    public func run<T: DBOperation>(_ operation: T) async throws -> T.Result where T.Transaction == Transaction {
        try await storage.open(readOnly: operation.readOnly) { transaction in
            try operation.execute(transaction)
        }
    }
}
