//
//  KeychainStorage.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

final class KeychainStorage: SecureStorage {
    // MARK: - Property
    private let service: String
    
    // MARK: - Initializer
    public init(service: String? = nil) {
        self.service = service ?? Bundle.main.bundleIdentifier ?? ""
    }
    
    // MARK: - Public
    public func create(_ data: Data, forKey key: String) throws {
        try add(.init(
            class: .genericPassword([
                .attributeAccount: key,
                .attributeService: service
            ]),
            value: .init([
                .valueData: data
            ])
        ))
    }
    
    public func read(forKey key: String) throws -> Data {
        try match(.init(
            queries: [
                .genericPassword([
                    .attributeAccount: key,
                    .attributeService: service
                ]),
                .match(.matchLimitOne)
            ],
            return: .return([
                .returnData: true
            ])
        ))
    }
    
    public func update(_ data: Data, forKey key: String) throws {
        try update(.init(
            queries: [
                .genericPassword([
                    .attributeAccount: key,
                    .attributeService: service
                ])
            ],
            values: [
                .value([
                    .valueData: data
                ])
            ]
        ))
    }
    
    public func delete(forKey key: String) throws {
        try delete(.init(
            queries: [
                .genericPassword([
                    .attributeAccount: key,
                    .attributeService: service
                ])
            ]
        ))
    }
    
    public func add(_ item: SIAddItem) throws {
        let status = SecItemAdd(item.attributes.cfDictionary, nil)
        
        guard status == errSecSuccess else {
            throw SecureStorageError.underlying(status)
        }
    }
    
    public func match(_ item: SIMatchItem) throws -> Data {
        var result: CFTypeRef?
        let status = SecItemCopyMatching(item.attributes.cfDictionary, &result)
        
        guard status == errSecSuccess else {
            throw SecureStorageError.underlying(status)
        }
        
        guard let data = result as? Data else {
            throw SecureStorageError.unknown
        }
        
        return data
    }
    
    public func update(_ item: SIUpdateItem) throws {
        let status = SecItemUpdate(item.queries.cfDictionary, item.attributes.cfDictionary)
        
        guard status == errSecSuccess else {
            throw SecureStorageError.underlying(status)
        }
    }
    
    public func delete(_ item: SIDeleteItem) throws {
        let status = SecItemDelete(item.queries.cfDictionary)
        
        guard status == errSecSuccess else {
            throw SecureStorageError.underlying(status)
        }
    }
    
    // MARK: - Private
}
