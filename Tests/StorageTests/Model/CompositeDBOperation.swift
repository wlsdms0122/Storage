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
        typealias Parameter = Never

        let name: String
        let readOnly: Bool
        let log: ProxyConnection<[String]>

        // MARK: - Public
        func execute(_ transaction: OverridingDBStorage.Handle) throws {
            log.value.append(name)
        }
    }

    // MARK: - Property
    typealias Parameter = Never

    let members: [Member]

    /// Answered by asking the members, which is something only a value can do —
    /// what this operation is depends on what it was built out of.
    var readOnly: Bool { members.allSatisfy(\.readOnly) }

    // MARK: - Initializer
    init(log: ProxyConnection<[String]> = ProxyConnection([]), readOnly: Bool = false) {
        self.members = [
            Member(name: "first", readOnly: readOnly, log: log),
            Member(name: "second", readOnly: readOnly, log: log)
        ]
    }

    // MARK: - Public
    func execute(_ transaction: OverridingDBStorage.Handle) throws {
        for member in members {
            try member.execute(transaction)
        }
    }
}
