//
//  SIClass.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public protocol SIClass: SIAttributes { }

// MARK: - Generic Password
public struct SIClassGenericPassword: SIClass {
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
        var attributes: [String: Any] = .init(
            uniqueKeysWithValues: attributes
                .map { ($0.rawValue, $1) }
        )
        
        attributes[SIKey.class.rawValue] = SIKey.classGenericPassword.rawValue
        
        self.attributes = attributes
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension SIClassGenericPassword.Key {
    static let attributeAccessControl: Self = .init(.attributeAccessControl)
    static let attributeAccessGroup: Self = .init(.attributeAccessGroup)
    static let attributeAccessible: Self = .init(.attributeAccessible)
    static let attributeCreationDate: Self = .init(.attributeCreationDate)
    static let attributeModificationDate: Self = .init(.attributeModificationDate)
    static let attributeDescription: Self = .init(.attributeDescription)
    static let attributeComment: Self = .init(.attributeComment)
    static let attributeCreator: Self = .init(.attributeCreator)
    static let attributeType: Self = .init(.attributeType)
    static let attributeLabel: Self = .init(.attributeLabel)
    static let attributeIsInvisible: Self = .init(.attributeIsInvisible)
    static let attributeIsNegative: Self = .init(.attributeIsNegative)
    static let attributeAccount: Self = .init(.attributeAccount)
    static let attributeService: Self = .init(.attributeService)
    static let attributeGeneric: Self = .init(.attributeGeneric)
    static let attributeSynchronizable: Self = .init(.attributeSynchronizable)
}

// MARK: - Internet Password
public struct SIClassInternetPassword: SIClass {
    public struct Key: Hashable, Sendable {
        // MARK: - Property
        let rawValue: String
        
        // MARK: - Initializer
        public init(_ key: SIKey) {
            self.rawValue = key.rawValue
        }
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    public nonisolated(unsafe) let attributes: [String: Any]
    
    // MARK: - Initializer
    public init(_ attributes: [Key: Any]) {
        var attributes: [String: Any] = .init(
            uniqueKeysWithValues: attributes
                .map { ($0.rawValue, $1) }
        )
        
        attributes[SIKey.class.rawValue] = SIKey.classInternetPassword.rawValue
        
        self.attributes = attributes
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension SIClassInternetPassword.Key {
    static let attributeAccessGroup: Self = .init(.attributeAccessGroup)
    static let attributeAccessible: Self = .init(.attributeAccessible)
    static let attributeCreationDate: Self = .init(.attributeCreationDate)
    static let attributeModificationDate: Self = .init(.attributeModificationDate)
    static let attributeDescription: Self = .init(.attributeDescription)
    static let attributeComment: Self = .init(.attributeComment)
    static let attributeCreator: Self = .init(.attributeCreator)
    static let attributeType: Self = .init(.attributeType)
    static let attributeLabel: Self = .init(.attributeLabel)
    static let attributeIsInvisible: Self = .init(.attributeIsInvisible)
    static let attributeIsNegative: Self = .init(.attributeIsNegative)
    static let attributeAccount: Self = .init(.attributeAccount)
    static let attributeSecurityDomain: Self = .init(.attributeSecurityDomain)
    static let attributeServer: Self = .init(.attributeServer)
    static let attributeProtocol: Self = .init(.attributeProtocol)
    static let attributeAuthenticationType: Self = .init(.attributeAuthenticationType)
    static let attributePort: Self = .init(.attributePort)
    static let attributePath: Self = .init(.attributePath)
    static let attributeSynchronizable: Self = .init(.attributeSynchronizable)
}

// MARK: - Certificate
public struct SIClassCertificate: SIClass {
    public struct Key: Hashable, Sendable {
        // MARK: - Property
        let rawValue: String
        
        // MARK: - Initializer
        public init(_ key: SIKey) {
            self.rawValue = key.rawValue
        }
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    public nonisolated(unsafe) let attributes: [String: Any]
    
    // MARK: - Initializer
    public init(_ attributes: [Key: Any]) {
        var attributes: [String: Any] = .init(
            uniqueKeysWithValues: attributes
                .map { ($0.rawValue, $1) }
        )
        
        attributes[SIKey.class.rawValue] = SIKey.classCertificate.rawValue
        
        self.attributes = attributes
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension SIClassCertificate.Key {
    static let attributeAccessGroup: Self = .init(.attributeAccessGroup)
    static let attributeAccessible: Self = .init(.attributeAccessible)
    static let attributeCertificateType: Self = .init(.attributeCertificateType)
    static let attributeCertificateEncoding: Self = .init(.attributeCertificateEncoding)
    static let attributeLabel: Self = .init(.attributeLabel)
    static let attributeSubject: Self = .init(.attributeSubject)
    static let attributeIssuer: Self = .init(.attributeIssuer)
    static let attributeSerialNumber: Self = .init(.attributeSerialNumber)
    static let attributeSubjectKeyID: Self = .init(.attributeSubjectKeyID)
    static let attributePublicKeyHash: Self = .init(.attributePublicKeyHash)
}

// MARK: - Key
public struct SIClassKey: SIClass {
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
    
    public nonisolated(unsafe) let attributes: [String: Any]
    
    // MARK: - Initializer
    public init(_ attributes: [Key: Any]) {
        var attributes: [String: Any] = .init(
            uniqueKeysWithValues: attributes
                .map { ($0.rawValue, $1) }
        )
        
        attributes[SIKey.class.rawValue] = SIKey.classKey.rawValue
        
        self.attributes = attributes
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension SIClassKey.Key {
    static let attributeAccessGroup: Self = .init(.attributeAccessGroup)
    static let attributeAccessible: Self = .init(.attributeAccessible)
    static let attributeKeyClass: Self = .init(.attributeKeyClass)
    static let attributeLabel: Self = .init(.attributeLabel)
    static let attributeApplicationLabel: Self = .init(.attributeApplicationLabel)
    static let attributeIsPermanent: Self = .init(.attributeIsPermanent)
    static let attributeApplicationTag: Self = .init(.attributeApplicationTag)
    static let attributeKeyType: Self = .init(.attributeKeyType)
    static let attributeKeySizeInBits: Self = .init(.attributeKeySizeInBits)
    static let attributeEffectiveKeySize: Self = .init(.attributeEffectiveKeySize)
    static let attributeCanEncrypt: Self = .init(.attributeCanEncrypt)
    static let attributeCanDecrypt: Self = .init(.attributeCanDecrypt)
    static let attributeCanDerive: Self = .init(.attributeCanDerive)
    static let attributeCanSign: Self = .init(.attributeCanSign)
    static let attributeCanVerify: Self = .init(.attributeCanVerify)
    static let attributeCanWrap: Self = .init(.attributeCanWrap)
    static let attributeCanUnwrap: Self = .init(.attributeCanUnwrap)
}

// MARK: - Identity
public struct SIClassIdentity: SIClass {
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
        var attributes: [String: Any] = .init(
            uniqueKeysWithValues: attributes
                .map { ($0.rawValue, $1) }
        )
        
        attributes[SIKey.class.rawValue] = SIKey.classIdentity.rawValue
        
        self.attributes = attributes
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension SIClassIdentity.Key {
    static let attributeAccessGroup: Self = .init(.attributeAccessGroup)
    static let attributeAccessible: Self = .init(.attributeAccessible)
    static let attributeKeyClass: Self = .init(.attributeKeyClass)
    static let attributeLabel: Self = .init(.attributeLabel)
    static let attributeApplicationLabel: Self = .init(.attributeApplicationLabel)
    static let attributeIsPermanent: Self = .init(.attributeIsPermanent)
    static let attributeApplicationTag: Self = .init(.attributeApplicationTag)
    static let attributeKeyType: Self = .init(.attributeKeyType)
    static let attributeKeySizeInBits: Self = .init(.attributeKeySizeInBits)
    static let attributeEffectiveKeySize: Self = .init(.attributeEffectiveKeySize)
    static let attributeCanEncrypt: Self = .init(.attributeCanEncrypt)
    static let attributeCanDecrypt: Self = .init(.attributeCanDecrypt)
    static let attributeCanDerive: Self = .init(.attributeCanDerive)
    static let attributeCanSign: Self = .init(.attributeCanSign)
    static let attributeCanVerify: Self = .init(.attributeCanVerify)
    static let attributeCanWrap: Self = .init(.attributeCanWrap)
    static let attributeCanUnwrap: Self = .init(.attributeCanUnwrap)
    static let attributeCertificateType: Self = .init(.attributeCertificateType)
    static let attributeCertificateEncoding: Self = .init(.attributeCertificateEncoding)
    static let attributeSubject: Self = .init(.attributeSubject)
    static let attributeIssuer: Self = .init(.attributeIssuer)
    static let attributeSerialNumber: Self = .init(.attributeSerialNumber)
    static let attributeSubjectKeyID: Self = .init(.attributeSubjectKeyID)
    static let attributePublicKeyHash: Self = .init(.attributePublicKeyHash)
}
