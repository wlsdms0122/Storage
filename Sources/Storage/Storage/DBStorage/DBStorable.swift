//
//  DBStorable.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation

public protocol DBStorable<Connection>: Sendable {
    associatedtype Connection
    
    func connect() async throws -> Connection
    func migrate(connection: Connection) async throws
    
    func reset() async throws
    
    func storage<T: DBTransaction>(_ stroage: Self, willRun transaction: T) where T.Connection == Connection
    func storage<T: DBTransaction>(_ storage: Self, didRun transaction: T, withResult result: Result<T.Result, any Error>) where T.Connection == Connection
}

public extension DBStorable {
    func initialize() async throws {
        try await migrate(connection: try await connect())
    }
    
    func reset() async throws {
        try await reset()
    }
    
    @discardableResult
    func run<T: DBTransaction>(_ transaction: T) async throws -> T.Result where T.Connection == Connection {
        storage(self, willRun: transaction)
        do {
            let result = try await transaction.execute(try connect())
            storage(self, didRun: transaction, withResult: .success(result))
            
            return result
        } catch {
            storage(self, didRun: transaction, withResult: .failure(error))
            throw error
        }
    }
    
    func storage<T: DBTransaction>(_ stroage: Self, willRun transaction: T) where T.Connection == Connection {
        
    }
    
    func storage<T: DBTransaction>(_ storage: Self, didRun transaction: T, withResult result: Result<T.Result, any Error>) where T.Connection == Connection {
        
    }
}
