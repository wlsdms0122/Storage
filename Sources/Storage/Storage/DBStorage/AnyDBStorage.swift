//
//  AnyDBStorage.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation

public class AnyDBStorage<S: DBStorage>: DBStorage {
    // MARK: - Property
    private let _connect: () throws -> S.Connection
    private let _migrate: (S.Connection) async throws -> Void
    private let _reset: () async throws -> Void
    
    // MARK: - Initializer
    public init(_ storage: S) {
        self._connect = storage.connect
        self._migrate = storage.migrate
        self._reset = storage.reset
    }
    
    // MARK: - Public
    public func connect() throws -> S.Connection {
        try _connect()
    }
    
    public func migrate(connection: S.Connection) async throws {
        try await _migrate(connection)
    }
    
    public func reset() async throws {
        try await _reset()
    }
    
    // MARK: - Private
}
