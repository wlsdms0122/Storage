//
//  StorageTests.swift
//  
//
//  Created by jsilver on 2023/02/15.
//

import XCTest
@testable import Storage

final class StorageTests: XCTestCase {
    // MARK: Property
    
    // MARK: - Lifecycle
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Test
    func test_that_add() throws {
        // Given
        let storage: any SecureStorage = KeychainStorage()
        
        let value = "value"
        
        // When
        try storage.create(value, forKey: "key")
        
        // Then
        let result: String = try storage.read(forKey: "key")
        
        XCTAssertEqual(value, result)
    }
}
