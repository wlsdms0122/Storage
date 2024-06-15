//
//  DBStorage.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation

public protocol DBStorage {
    associatedtype Connection
    
    func connect() throws -> Connection
    func migrate(connection: Connection) async throws
    
    func reset() async throws
}

public extension DBStorage {
    func initialize() async throws {
        try await migrate(connection: try connect())
    }
    
    @discardableResult
    func run<T: DBTransaction>(_ transaction: T) async throws -> T.Result where T.Connection == Connection {
        try await transaction.execute(try connect())
    }
}
