//
//  DBStorageTests.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation
import XCTest
@testable import Storage

final class DBStorageTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    // MARK: - Test
    func test_that_initialize_calls_connect_in_storage() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let sut = AnyDBStorage(
            ProxyDBStorage(
                connect: { 
                    connection.value.append(0)
                    return connection
                }
            )
        )
        
        // When
        try await sut.initialize()
        
        // Then
        XCTAssertEqual(connection.value.count, 1)
    }
    
    func test_that_initialize_calls_migration_in_storage() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let sut = AnyDBStorage(
            ProxyDBStorage(
                connect: { connection },
                migrate: { _ in connection.value.append(0) }
            )
        )
        
        // When
        try await sut.initialize()
        
        // Then
        XCTAssertEqual(connection.value.count, 1)
    }
    
    func test_that_transaction_is_applied_when_run_on_storage() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let sut = AnyDBStorage(
            ProxyDBStorage(
                connect: { connection }
            )
        )
        try await sut.initialize()
        
        // When
        try await sut.run(ProxyDBTransaction(true) { parameter, connection in
            connection.value.append(0)
        })
        
        // Then
        XCTAssertEqual(connection.value.count, 1)
    }
    
    func test_that_throws_error_when_run_called_without_initializing_storage() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let sut = AnyDBStorage(
            ProxyDBStorage(
                connect: { connection }
            )
        )
        try await sut.initialize()
        
        // When
        try await sut.run(ProxyDBTransaction(true) { parameter, connection in
            connection.value.append(0)
        })
        
        // Then
        XCTAssertEqual(connection.value.count, 1)
    }
    
    func test_that_reset_clears_all_data_in_storage() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([0])
        let sut = AnyDBStorage(
            ProxyDBStorage(
                connect: { connection },
                reset: { _ in connection.value.removeAll() }
            )
        )
        try await sut.initialize()
        
        // When
        try await sut.reset()
        
        // Then
        XCTAssertEqual(connection.value.count, 0)
    }
}
