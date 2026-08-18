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
    let readOnly: Bool

    private let _execute: @Sendable (Parameter, Transaction) throws -> Result

    // MARK: - Initializer
    init(
        _ parameter: Parameter,
        readOnly: Bool = false,
        execute: @escaping @Sendable (Parameter, Transaction) throws -> Result
    ) {
        self.parameter = parameter
        self.readOnly = readOnly
        self._execute = execute
    }

    // MARK: - Lifecycle
    func execute(_ transaction: Transaction) throws -> Result {
        try _execute(parameter, transaction)
    }

    // MARK: - Public

    // MARK: - Private
}
