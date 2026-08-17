//
//  ParameterlessDBTransaction.swift
//
//
//  Created by jsilver on 8/17/26.
//

import Foundation
@testable import Storage

/// A transaction that takes nothing. It names no `Parameter`, which is the point:
/// this only compiles because the protocol defaults it.
struct ParameterlessDBTransaction: DBTransaction {
    // MARK: - Lifecycle
    func execute(_ connection: ProxyConnection<[Int]>) async throws -> Int {
        connection.value.count
    }
}
