//
//  InMemoryDBStorage.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation
@testable import Storage

final class ProxyConnection<Connection: Sendable>: Sendable {
    nonisolated(unsafe) var value: Connection
    
    init(_ value: Connection) {
        self.value = value
    }
}

final class ProxyDBStorage<Connection: Sendable>: DBStorable {
    private nonisolated(unsafe) var connection: Connection?
    
    private let _connect: @Sendable () throws -> Connection
    private let _migrate: @Sendable (Connection) async throws -> Void
    private let _reset: @Sendable (Connection?) async throws -> Void
    
    init(
        connect: @escaping @Sendable () throws -> Connection,
        migrate: @escaping @Sendable (Connection) async throws -> Void = { _ in },
        reset: @escaping @Sendable (Connection?) async throws -> Void = { _ in }
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
    
    // The connection is the transaction here — the shape of a database that does
    // not hand out a separate handle, and that has nothing cheaper to offer a
    // read.
    func open<T>(readOnly: Bool, _ body: @escaping @Sendable (Connection) throws -> T) async throws -> T {
        try body(try connect())
    }
}
