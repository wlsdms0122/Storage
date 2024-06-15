//
//  UserDefaultStorage.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

open class UserDefaultStorage: Storage {
    // MARK: - Property
    private let userDefaults: UserDefaults
    
    // MARK: - Initializer
    public init(userDefsults: UserDefaults = .standard) {
        self.userDefaults = userDefsults
    }
    
    // MARK: - Public
    public func create(_ data: Data, forKey key: String) throws {
        guard userDefaults.data(forKey: key) == nil else {
            throw StorageError.alreadyExsit
        }
        userDefaults.set(data, forKey: key)
    }
    
    public func read(forKey key: String) throws -> Data {
        guard let data = userDefaults.data(forKey: key) else {
            throw StorageError.notFound
        }
        return data
    }
    
    public func update(_ data: Data, forKey key: String) throws {
        guard userDefaults.data(forKey: key) != nil else {
            throw StorageError.notFound
        }
        userDefaults.set(data, forKey: key)
    }
    
    public func delete(forKey key: String) throws {
        guard userDefaults.data(forKey: key) != nil else {
            throw StorageError.notFound
        }
        userDefaults.removeObject(forKey: key)
    }
    
    // MARK: - Private
}
