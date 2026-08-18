//
//  ParameterlessDBOperation.swift
//
//
//  Created by jsilver on 8/17/26.
//

import Foundation
@testable import Storage

/// An operation that takes nothing — and says so.
struct ParameterlessDBOperation: DBOperation {
    // MARK: - Property
    typealias Parameter = Never

    // MARK: - Lifecycle
    func execute(_ transaction: ProxyConnection<[Int]>) throws -> Int {
        transaction.value.count
    }
}
