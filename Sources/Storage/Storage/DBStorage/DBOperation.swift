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

    @discardableResult
    func execute(_ transaction: Transaction) throws -> Result
}

/// An operation that only reads.
///
/// It says so rather than being held to it: the storage opens a read-only
/// transaction for it, which is what a database can do something with — skip
/// the write lock, take a reader from the pool, route to a replica. Whether
/// writing through one is refused is the database's answer, not this protocol's.
public protocol DBReadOperation: DBOperation { }
