//
//  InMemoryDBStorage.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation
@testable import Storage

class ProxyConnection<Connection> {
    var value: Connection
    
    init(_ value: Connection) {
        self.value = value
    }
}

class ProxyDBStorage<Connection>: DBStorage {
    private var connection: Connection?
    
    private let _connect: () throws -> Connection
    private let _migrate: (Connection) async throws -> Void
    private let _reset: (Connection?) async throws -> Void
    
    init(
        connect: @escaping () throws -> Connection,
        migrate: @escaping (Connection) async throws -> Void = { _ in },
        reset: @escaping (Connection?) async throws -> Void = { _ in }
    ) {
        self._connect = connect
        self._migrate = migrate
        self._reset = reset
    }
    
    func connect() throws -> Connection {
        if let connection {
            return connection
        }
        
        let connection = try _connect()
        self.connection = connection
        
        return connection
    }
    
    func migrate(connection: Connection) async throws {
        try await _migrate(connection)
    }
    
    func reset() async throws {
        try await _reset(connection)
    }
}
