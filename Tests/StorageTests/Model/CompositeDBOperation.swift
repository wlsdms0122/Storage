//
//  CompositeDBOperation.swift
//
//
//  Created by jsilver on 8/18/26.
//

import Foundation
@testable import Storage

/// An operation built out of operations. It needs no new concept — an operation
/// runs in a transaction it was handed, so handing the same one on is all
/// composing takes, and the members commit together.
struct CompositeDBOperation: DBOperation {
    struct Member: DBOperation {
        // MARK: - Property
        let name: String

        // MARK: - Public
        func execute(_ transaction: OverridingDBStorage.Handle) throws {
            CompositeDBOperation.log.value.append(name)
        }
    }

    // MARK: - Property
    nonisolated(unsafe) static let log = ProxyConnection<[String]>([])

    // MARK: - Public
    func execute(_ transaction: OverridingDBStorage.Handle) throws {
        try Member(name: "first").execute(transaction)
        try Member(name: "second").execute(transaction)
    }
}
