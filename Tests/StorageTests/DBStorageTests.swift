//
//  DBStorableTests.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation
import XCTest
@testable import Storage

final class DBStorableTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    // MARK: - Test
    func test_that_initialize_calls_connect_in_storage() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let sut: any DBStorable = ProxyDBStorage(
            connect: {
                connection.value.append(0)
                return connection
            }
        )
        
        // When
        try await sut.initialize()
        
        // Then
        XCTAssertEqual(connection.value.count, 1)
    }
    
    func test_that_initialize_calls_migration_in_storage() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let sut: any DBStorable = ProxyDBStorage(
            connect: { connection },
            migrate: { _ in connection.value.append(0) }
        )
        
        // When
        try await sut.initialize()
        
        // Then
        XCTAssertEqual(connection.value.count, 1)
    }
    
    func test_that_operation_is_applied_when_run_on_storage() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let sut: any DBStorable<ProxyConnection<[Int]>, ProxyConnection<[Int]>> = ProxyDBStorage(
            connect: { connection }
        )
        try await sut.initialize()
        
        // When
        try await sut.run(ProxyDBOperation(true) { parameter, connection in
            connection.value.append(0)
        })
        
        // Then
        XCTAssertEqual(connection.value.count, 1)
    }
    
    func test_that_storage_opens_a_write_transaction_for_an_operation() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let opened = ProxyConnection<[String]>([])
        let sut: any DBStorable<ProxyConnection<[Int]>, OverridingDBStorage.Handle> = OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        )

        // When
        let readOnly = try await sut.run(ProxyDBOperation(true) { _, handle in handle.readOnly })

        // Then
        XCTAssertEqual(opened.value, ["write"])
        XCTAssertFalse(readOnly)
    }

    func test_that_storage_opens_a_read_transaction_for_a_read_operation() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let opened = ProxyConnection<[String]>([])
        let sut: any DBStorable<ProxyConnection<[Int]>, OverridingDBStorage.Handle> = OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        )

        // When
        let readOnly = try await sut.run(ProxyDBReadOperation(true) { _, handle in handle.readOnly })

        // Then
        XCTAssertEqual(opened.value, ["read"])
        XCTAssertTrue(readOnly)
    }

    func test_that_hooks_are_called_on_both_kinds_of_operation() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let hooks = ProxyConnection<[String]>([])
        let sut: any DBStorable<ProxyConnection<[Int]>, OverridingDBStorage.Handle> = OverridingDBStorage(
            connect: { connection },
            hook: { hooks.value.append($0) }
        )

        // When
        try await sut.run(ProxyDBOperation(true) { _, _ in })
        try await sut.run(ProxyDBReadOperation(true) { _, _ in })

        // Then
        XCTAssertEqual(hooks.value, ["willRun", "didRun", "willRun", "didRun"])
    }

    func test_that_operations_composed_into_one_share_a_transaction() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let opened = ProxyConnection<[String]>([])
        let sut: any DBStorable<ProxyConnection<[Int]>, OverridingDBStorage.Handle> = OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        )

        // When
        try await sut.run(CompositeDBOperation())

        // Then — one transaction, not one per member.
        XCTAssertEqual(opened.value, ["write"])
        XCTAssertEqual(CompositeDBOperation.log.value, ["first", "second"])
    }

    // `Parameter` is resolved statically, so the assertion is that
    // `ParameterlessDBOperation` — which declares none — compiles at all. This
    // runs it to keep the double from going unused.
    func test_that_operation_without_a_declared_parameter_runs() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([0, 0])
        let sut: any DBStorable<ProxyConnection<[Int]>, ProxyConnection<[Int]>> = ProxyDBStorage(
            connect: { connection }
        )

        // When
        let result = try await sut.run(ParameterlessDBOperation())

        // Then
        XCTAssertEqual(result, 2)
    }

    func test_that_reset_clears_all_data_in_storage() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([0])
        let sut: any DBStorable<ProxyConnection<[Int]>, ProxyConnection<[Int]>> = ProxyDBStorage(
            connect: { connection },
            reset: { _ in connection.value.removeAll() }
        )
        try await sut.initialize()
        
        // When
        try await sut.reset()
        
        // Then
        XCTAssertEqual(connection.value.count, 0)
    }
}
