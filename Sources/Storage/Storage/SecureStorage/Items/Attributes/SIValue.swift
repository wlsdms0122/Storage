//
//  SIValue.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIValue: SIAttributes {
    public struct Key: Hashable, Sendable {
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
    public nonisolated(unsafe) let attributes: [String: Any]
    
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

public extension SIValue.Key {
    static let valueData: Self = .init(.valueData)
    static let valueRef: Self = .init(.valueRef)
    static let valuePersistentRef: Self = .init(.valuePersistentRef)
}
