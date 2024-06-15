//
//  SIMatch.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIMatch: SIAttributes {
    public struct Value {
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
    public init(_ value: Value) {
        self.attributes = [SIKey.matchLimit.rawValue: value.rawValue]
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension SIMatch.Value {
    static let matchLimitOne: Self = .init(.matchLimitOne)
    static let matchLimitAll: Self = .init(.matchLimitAll)
}
