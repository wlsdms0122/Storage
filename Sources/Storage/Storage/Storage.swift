//
//  Storage.swift
//  
//
//  Created by jsilver on 2022/02/06.
//

import Foundation

public protocol Storage {
    /// Create the item for key.
    func create(_ data: Data, forKey key: String) throws
    /// Read the item for key.
    func read(forKey key: String) throws -> Data
    /// Update the item for key.
    func update(_ data: Data, forKey key: String) throws
    /// Remove the item for key.
    func delete(forKey key: String) throws
}

public extension Storage {
    func create<Value: Encodable>(_ value: Value, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        
        try create(data, forKey: key)
    }
    
    func read<Value: Decodable>(_ type: Value.Type = Value.self, forKey key: String) throws -> Value {
        let data = try read(forKey: key)
        
        return try JSONDecoder().decode(type, from: data)
    }
    
    func update<Value: Encodable>(_ value: Value, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        
        try update(data, forKey: key)
    }
}
