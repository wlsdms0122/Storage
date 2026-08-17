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
    
    /// Runs the transaction on an open connection. Defaults to the transaction's
    /// own `execute`; a storage that has to hold something around every
    /// transaction — a lock, a queue, a metric — holds it here.
    ///
    /// This is the step a storage takes over, rather than `run` itself, so that
    /// opening the connection and calling the hooks stay where they are and a
    /// storage cannot lose them by answering this.
    func execute<T: DBTransaction>(_ transaction: T, on connection: Connection) async throws -> T.Result where T.Connection == Connection
    
    func storage<T: DBTransaction>(_ storage: Self, willRun transaction: T) where T.Connection == Connection
    func storage<T: DBTransaction>(_ storage: Self, didRun transaction: T, withResult result: Result<T.Result, any Error>) where T.Connection == Connection
}

public extension DBStorable {
    func initialize() async throws {
        try await migrate(connection: try await connect())
    }
    
    func execute<T: DBTransaction>(_ transaction: T, on connection: Connection) async throws -> T.Result where T.Connection == Connection {
        try await transaction.execute(connection)
    }
    
    @discardableResult
    func run<T: DBTransaction>(_ transaction: T) async throws -> T.Result where T.Connection == Connection {
        storage(self, willRun: transaction)
        do {
            let result = try await execute(transaction, on: try await connect())
            storage(self, didRun: transaction, withResult: .success(result))
            
            return result
        } catch {
            storage(self, didRun: transaction, withResult: .failure(error))
            throw error
        }
    }
    
    func storage<T: DBTransaction>(_ storage: Self, willRun transaction: T) where T.Connection == Connection {
        
    }
    
    func storage<T: DBTransaction>(_ storage: Self, didRun transaction: T, withResult result: Result<T.Result, any Error>) where T.Connection == Connection {
        
    }
}
