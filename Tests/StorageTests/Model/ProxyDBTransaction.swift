//
//  ProxyDBTransaction.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation
@testable import Storage

struct ProxyDBTransaction<Connection, Parameter: Sendable, Result>: DBTransaction {
    // MARK: - Property
    let parameter: Parameter
    private let _execute: @Sendable (Parameter, Connection) -> Result
    
    // MARK: - Initializer
    init(_ parameter: Parameter, execute: @escaping @Sendable (Parameter, Connection) -> Result) {
        self.parameter = parameter
        self._execute = execute
    }
    
    // MARK: - Lifecycle
    func execute(_ connection: Connection) async throws -> Result {
        _execute(parameter, connection)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
