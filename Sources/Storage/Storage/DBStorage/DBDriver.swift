//
//  DBDriver.swift
//
//
//  Created by jsilver on 8/18/26.
//

import Foundation

/// How one particular database is put together — connected, brought up to the
/// current schema, emptied.
///
/// This is the half of a store that differs per engine, and the half nobody
/// above the composition root has business calling. `DB` is what the tiers
/// above hold, and it keeps its driver to itself.
public protocol DBDriver {
    /// The channel to the database — expensive to open, long-lived, reused
    /// across transactions. Whether one is pooled, cached or reopened is the
    /// driver's business.
    associatedtype Connection

    func connect() async throws -> Connection

    func migrate(connection: Connection) async throws

    /// Brings the database to the state where a transaction can be opened.
    ///
    /// The order is the driver's answer rather than this protocol's: a database
    /// whose connection refuses while migrations are pending cannot be made
    /// ready by connecting first.
    func initialize() async throws

    /// Drops everything the database holds, leaving it at the schema it was
    /// migrated to — emptied, not unmade. A caller that resets does not have to
    /// initialize again.
    func reset() async throws
}
