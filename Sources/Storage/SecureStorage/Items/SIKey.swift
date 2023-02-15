//
//  SIKey.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIKey: Hashable {
    // MARK: - Property
    public let rawValue: String
    
    // MARK: - Initializer
    public init(_ rawValue: CFString) {
        self.rawValue = String(rawValue)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension SIKey {
    // Class
    static let `class`: Self = .init(kSecClass)
    static let classGenericPassword: Self = .init(kSecClassGenericPassword)
    static let classInternetPassword: Self = .init(kSecClassInternetPassword)
    static let classCertificate: Self = .init(kSecClassCertificate)
    static let classKey: Self = .init(kSecClassKey)
    static let classIdentity: Self = .init(kSecClassIdentity)
    
    // Attribute
    static let attributeAccessible: Self = .init(kSecAttrAccessible)
    static let attributeAccessControl: Self = .init(kSecAttrAccessControl)
    static let attributeAccessGroup: Self = .init(kSecAttrAccessGroup)
    static let attributeSynchronizable: Self = .init(kSecAttrSynchronizable)
    static let attributeCreationDate: Self = .init(kSecAttrCreationDate)
    static let attributeModificationDate: Self = .init(kSecAttrModificationDate)
    static let attributeDescription: Self = .init(kSecAttrDescription)
    static let attributeComment: Self = .init(kSecAttrComment)
    static let attributeCreator: Self = .init(kSecAttrCreator)
    static let attributeType: Self = .init(kSecAttrType)
    static let attributeLabel: Self = .init(kSecAttrLabel)
    static let attributeIsInvisible: Self = .init(kSecAttrIsInvisible)
    static let attributeIsNegative: Self = .init(kSecAttrIsNegative)
    static let attributeAccount: Self = .init(kSecAttrAccount)
    static let attributeService: Self = .init(kSecAttrService)
    static let attributeGeneric: Self = .init(kSecAttrGeneric)
    static let attributeSecurityDomain: Self = .init(kSecAttrSecurityDomain)
    static let attributeServer: Self = .init(kSecAttrServer)
    static let attributeProtocol: Self = .init(kSecAttrProtocol)
    static let attributeAuthenticationType: Self = .init(kSecAttrAuthenticationType)
    static let attributePort: Self = .init(kSecAttrPort)
    static let attributePath: Self = .init(kSecAttrPath)
    static let attributeCertificateType: Self = .init(kSecAttrCertificateType)
    static let attributeCertificateEncoding: Self = .init(kSecAttrCertificateEncoding)
    static let attributeSubject: Self = .init(kSecAttrSubject)
    static let attributeIssuer: Self = .init(kSecAttrIssuer)
    static let attributeSerialNumber: Self = .init(kSecAttrSerialNumber)
    static let attributeSubjectKeyID: Self = .init(kSecAttrSubjectKeyID)
    static let attributePublicKeyHash: Self = .init(kSecAttrPublicKeyHash)
    static let attributeKeyClass: Self = .init(kSecAttrKeyClass)
    static let attributeApplicationLabel: Self = .init(kSecAttrApplicationLabel)
    static let attributeIsPermanent: Self = .init(kSecAttrIsPermanent)
    static let attributeApplicationTag: Self = .init(kSecAttrApplicationTag)
    static let attributeKeyType: Self = .init(kSecAttrKeyType)
    static let attributeKeySizeInBits: Self = .init(kSecAttrKeySizeInBits)
    static let attributeEffectiveKeySize: Self = .init(kSecAttrEffectiveKeySize)
    static let attributeCanEncrypt: Self = .init(kSecAttrCanEncrypt)
    static let attributeCanDecrypt: Self = .init(kSecAttrCanDecrypt)
    static let attributeCanDerive: Self = .init(kSecAttrCanDerive)
    static let attributeCanSign: Self = .init(kSecAttrCanSign)
    static let attributeCanVerify: Self = .init(kSecAttrCanVerify)
    static let attributeCanWrap: Self = .init(kSecAttrCanWrap)
    static let attributeCanUnwrap: Self = .init(kSecAttrCanUnwrap)
    
    // Synchronizable
    static let synchronizableAny = kSecAttrSynchronizableAny
    
    // Match
    static let matchPolicy: Self = .init(kSecMatchPolicy)
    static let matchItemList: Self = .init(kSecMatchItemList)
    static let matchSearchList: Self = .init(kSecMatchSearchList)
    static let matchIssuers: Self = .init(kSecMatchIssuers)
    static let matchEmailAddressIfPresent: Self = .init(kSecMatchEmailAddressIfPresent)
    static let matchSubjectContains: Self = .init(kSecMatchSubjectContains)
    static let matchCaseInsensitive: Self = .init(kSecMatchCaseInsensitive)
    static let matchTrustedOnly: Self = .init(kSecMatchTrustedOnly)
    static let matchValidOnDate: Self = .init(kSecMatchValidOnDate)
    static let matchLimit: Self = .init(kSecMatchLimit)
    static let matchLimitOne: Self = .init(kSecMatchLimitOne)
    static let matchLimitAll: Self = .init(kSecMatchLimitAll)
    
    // Use
    static let useOperationPrompt = {
        if #available(iOS 14.0, *) {
            return String(kSecUseAuthenticationContext)
        } else {
            return String(kSecUseOperationPrompt)
        }
    }()
    static let useNoAuthenticationUI: Self = .init(kSecUseAuthenticationUI)
    static let useAuthenticationUI: Self = .init(kSecUseAuthenticationUI)
    static let useAuthenticationContext: Self = .init(kSecUseAuthenticationContext)
    static let useAuthenticationUIAllow: Self = .init(kSecUseAuthenticationUIAllow)
    static let useAuthenticationUIFail: Self = .init(kSecUseAuthenticationUIFail)
    static let useAuthenticationUISkip: Self = .init(kSecUseAuthenticationUISkip)
    static let useDataProtectionKeychain: Self = .init(kSecUseDataProtectionKeychain)
    
    // Return
    static let returnData: Self = .init(kSecReturnData)
    static let returnAttributes: Self = .init(kSecReturnAttributes)
    static let returnRef: Self = .init(kSecReturnRef)
    static let returnPersistentRef: Self = .init(kSecReturnPersistentRef)
    
    // Value
    static let valueData: Self = .init(kSecValueData)
    static let valueRef: Self = .init(kSecValueRef)
    static let valuePersistentRef: Self = .init(kSecValuePersistentRef)
}
