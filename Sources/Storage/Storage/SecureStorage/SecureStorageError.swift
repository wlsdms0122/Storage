//
//  SecureStorageError.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public enum SecureStorageError: Error, Sendable {
    /// Unknown error.
    case unknown
    /// Secure error.
    case underlying(OSStatus)
}
