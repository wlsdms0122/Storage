//
//  ProxyDBOperation.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation
@testable import Storage

struct ProxyDBOperation<Transaction, Parameter: Sendable, Result>: DBOperation {
    // MARK: - Property
    let parameter: Parameter
    private let _execute: @Sendable (Parameter, Transaction) -> Result

    // MARK: - Initializer
    init(_ parameter: Parameter, execute: @escaping @Sendable (Parameter, Transaction) -> Result) {
        self.parameter = parameter
        self._execute = execute
    }

    // MARK: - Lifecycle
    func execute(_ transaction: Transaction) throws -> Result {
        _execute(parameter, transaction)
    }

    // MARK: - Public

    // MARK: - Private
}

/// The same, declaring that it only reads — so a storage that separates the two
/// can be caught opening the other kind of transaction for it.
struct ProxyDBReadOperation<Transaction, Parameter: Sendable, Result>: DBReadOperation {
    // MARK: - Property
    let parameter: Parameter
    private let _execute: @Sendable (Parameter, Transaction) -> Result

    // MARK: - Initializer
    init(_ parameter: Parameter, execute: @escaping @Sendable (Parameter, Transaction) -> Result) {
        self.parameter = parameter
        self._execute = execute
    }

    // MARK: - Lifecycle
    func execute(_ transaction: Transaction) throws -> Result {
        _execute(parameter, transaction)
    }

    // MARK: - Public

    // MARK: - Private
}
