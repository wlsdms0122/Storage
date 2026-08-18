//
//  DBOperation.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation

/// One thing done to a database, inside a transaction someone else opened.
///
/// Opening one is the storage's job, so an operation claims no atomicity of its
/// own — which is what lets two of them commit together, and what makes an
/// operation built out of other operations still an operation.
public protocol DBOperation: Sendable {
    associatedtype Transaction
    /// What the operation takes — `Never` when it takes nothing.
    associatedtype Parameter
    associatedtype Result

    /// Whether this operation only reads, so the store can open a cheaper
    /// transaction for it.
    ///
    /// It is a value on the operation rather than a type it conforms to,
    /// because a type is read at the call site and an operation handed through
    /// a generic parameter arrives with that reading already lost — silently,
    /// as a read that takes the write lock. A value travels with the operation.
    /// It also lets an operation composed of others answer by asking them.
    ///
    /// Whether writing through a read-only transaction is refused is the
    /// database's answer, not this protocol's.
    var readOnly: Bool { get }

    @discardableResult
    func execute(_ transaction: Transaction) throws -> Result
}

public extension DBOperation {
    /// Writing is the assumption an operation is safe to be wrong about: a
    /// write transaction runs a read correctly, and only pays for it.
    var readOnly: Bool { false }
}
