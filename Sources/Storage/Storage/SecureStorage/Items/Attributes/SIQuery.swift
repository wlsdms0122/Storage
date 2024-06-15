//
//  SIQuery.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIQuery: SIAttributes {
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

public extension SIQuery.Key {
    static let matchPolicy: Self = .init(.matchPolicy)
    static let matchItemList: Self = .init(.matchItemList)
    static let matchSearchList: Self = .init(.matchSearchList)
    static let matchIssuers: Self = .init(.matchIssuers)
    static let matchEmailAddressIfPresent: Self = .init(.matchEmailAddressIfPresent)
    static let matchSubjectContains: Self = .init(.matchSubjectContains)
    static let matchCaseInsensitive: Self = .init(.matchCaseInsensitive)
    static let matchTrustedOnly: Self = .init(.matchTrustedOnly)
    static let matchValidOnDate: Self = .init(.matchValidOnDate)
    static let useAuthenticationUI: Self = .init(.useAuthenticationUI)
    static let useAuthenticationContext: Self = .init(.useAuthenticationContext)
    static let useDataProtectionKeychain: Self = .init(.useDataProtectionKeychain)
    static let useAuthenticationUISkip: Self = .init(.useAuthenticationUISkip)
}
