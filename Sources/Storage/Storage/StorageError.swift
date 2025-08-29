//
//  StorageError.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public enum StorageError: Error, Sendable {
    /// Unknown error.
    case unknown
    /// Item not found for key.
    case notFound
    /// Item already exist.
    case alreadyExsit
}
