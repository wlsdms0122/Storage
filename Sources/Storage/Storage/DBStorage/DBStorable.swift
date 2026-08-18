//
//  DBStorable.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation

/// The ability to open a transaction — a store as the work above it uses one.
///
/// How the database was connected and migrated is not here; that is `DBDriver`.
/// Splitting the two is what lets a store put a lock or a gate inside `open`
/// and have it hold for every caller, because `open` is the whole of what this
/// face offers.
public protocol DBStorable<Transaction>: Sendable {
    /// The open transaction this store hands out — the commit boundary that
    /// operations run inside. One connection serves many of these, in sequence.
    associatedtype Transaction

    /// Opens one transaction and hands it to the body. Everything the body does
    /// commits together or not at all.
    ///
    /// The body is synchronous because a transaction is a serialized session:
    /// the databases this abstracts hand out a handle valid only inside such a
    /// block. Waiting for the transaction is the caller's, and stays async.
    ///
    /// `readOnly` is what the caller's operation declared, passed on so the
    /// store can open a cheaper transaction for it — skip the write lock, take
    /// a reader from the pool, route to a replica. A database that does not
    /// distinguish the two ignores it, in the open.
    func open<T>(readOnly: Bool, _ body: @escaping @Sendable (Transaction) throws -> T) async throws -> T
}
