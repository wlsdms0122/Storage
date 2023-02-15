//
//  SIReturn.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIReturn: SIAttributes {
    public struct Key: Hashable {
        // MARK: - Property
        public let rawValue: String
        
        // MARK: - Initializer
        public init(_ key: SIKey) {
            self.rawValue = key.rawValue
        }
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    // MARK: - Property
    public let attributes: [String: Any]
    
    // MARK: - Initializer
    public init(_ attributes: [Key: Any]) {
        self.attributes = .init(
            uniqueKeysWithValues: attributes
                .map { ($0.rawValue, $1) }
        )
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension SIReturn.Key {
    static let returnData: Self = .init(.returnData)
    static let returnAttributes: Self = .init(.returnAttributes)
    static let returnRef: Self = .init(.returnRef)
    static let returnPersistentRef: Self = .init(.returnPersistentRef)
}
