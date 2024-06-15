//
//  SecureStorage.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public protocol SecureStorage: Storage {
    /// Add secure item.
    func add(_ item: SIAddItem) throws
    /// Fetch matched secure item.
    func match(_ item: SIMatchItem) throws -> Data
    /// Update secure item.
    func update(_ item: SIUpdateItem) throws
    /// Delete secure item.
    func delete(_ item: SIDeleteItem) throws
}
