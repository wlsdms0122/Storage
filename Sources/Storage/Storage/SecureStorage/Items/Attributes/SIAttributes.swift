//
//  SIAttributes.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public protocol SIAttributes {
    associatedtype Key: Hashable = String
    associatedtype Value = Any
    
    var attributes: [String: Any] { get }
}

public extension SIAttributes {
    static func genericPassword(_ attributes: [Key: Any]) -> Self where Self == SIClassGenericPassword {
        SIClassGenericPassword(attributes)
    }
    static func internetPassword(_ attributes: [Key: Any]) -> Self where Self == SIClassInternetPassword {
        SIClassInternetPassword(attributes)
    }
    static func certificate(_ attributes: [Key: Any]) -> Self where Self == SIClassCertificate {
        SIClassCertificate(attributes)
    }
    static func key(_ attributes: [Key: Any]) -> Self where Self == SIClassKey {
        SIClassKey(attributes)
    }
    static func identity(_ attributes: [Key: Any]) -> Self where Self == SIClassIdentity {
        SIClassIdentity(attributes)
    }
    static func query(_ attributes: [Key: Any]) -> Self where Self == SIQuery {
        SIQuery(attributes)
    }
    static func match(_ value: Value) -> Self where Self == SIMatch {
        SIMatch(value)
    }
    static func value(_ attributes: [Key: Any]) -> Self where Self == SIValue {
        SIValue(attributes)
    }
    static func `return`(_ attributes: [Key: Any]) -> Self where Self == SIReturn {
        SIReturn(attributes)
    }
}
