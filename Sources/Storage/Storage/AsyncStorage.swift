//
//  AsyncStorage.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public protocol AsyncStorage: Sendable {
    /// Create the item for key asynchronously.
    func create(_ data: Data, forKey key: String, completion: (Result<Void, Error>) -> Void)
    /// Read the item for key asynchronously.
    func read(forKey key: String, completion: (Result<Data, Error>) -> Void)
    /// Update the item for key asynchronously.
    func update(_ data: Data, forKey key: String, completion: (Result<Void, Error>) -> Void)
    /// Remove the item for key asynchronously.
    func delete(forKey key: String, completion: (Result<Void, Error>) -> Void)
}

public extension AsyncStorage {
    func create(_ data: Data, forKey key: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            create(data, forKey: key) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func read(forKey key: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            read(forKey: key) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func update(_ data: Data, forKey key: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            update(data, forKey: key) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func delete(forKey key: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            delete(forKey: key) { result in
                continuation.resume(with: result)
            }
        }
    }
}
