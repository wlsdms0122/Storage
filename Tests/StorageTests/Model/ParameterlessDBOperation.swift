//
//  ParameterlessDBOperation.swift
//
//
//  Created by jsilver on 8/17/26.
//

import Foundation
@testable import Storage

/// An operation that takes nothing. It names no `Parameter`, which is the point:
/// this only compiles because the protocol defaults it.
struct ParameterlessDBOperation: DBOperation {
    // MARK: - Lifecycle
    func execute(_ transaction: ProxyConnection<[Int]>) throws -> Int {
        transaction.value.count
    }
}
