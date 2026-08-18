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
        let sut: any DBDriver = ProxyDBStorage(
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
        let sut: any DBDriver = ProxyDBStorage(
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
        let sut = ProxyDBStorage(connect: { connection })
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
        let sut: any DBStorable<OverridingDBStorage.Handle> = OverridingDBStorage(
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
        let sut: any DBStorable<OverridingDBStorage.Handle> = OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        )

        // When
        let readOnly = try await sut.run(ProxyDBOperation(true, readOnly: true) { _, handle in handle.readOnly })

        // Then
        XCTAssertEqual(opened.value, ["read"])
        XCTAssertTrue(readOnly)
    }

    func test_that_operations_composed_into_one_share_a_transaction() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let opened = ProxyConnection<[String]>([])
        let sut: any DBStorable<OverridingDBStorage.Handle> = OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        )

        let log = ProxyConnection<[String]>([])

        // When
        try await sut.run(CompositeDBOperation(log: log))

        // Then — one transaction, not one per member.
        XCTAssertEqual(opened.value, ["write"])
        XCTAssertEqual(log.value, ["first", "second"])
    }

    // A marker on the type could not have said this: what kind of transaction a
    // composed operation needs is not a property of its type but of what it was
    // built out of, which is known only once it exists.
    func test_that_a_composed_operation_answers_from_its_members() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let opened = ProxyConnection<[String]>([])
        let sut: any DBStorable<OverridingDBStorage.Handle> = OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        )

        // When
        try await sut.run(CompositeDBOperation(readOnly: true))

        // Then
        XCTAssertEqual(opened.value, ["read"])
    }

    // `readOnly` travels with the operation, so it survives a generic parameter
    // whose constraint says nothing about reading. An overload resolved from the
    // static type could not — the call below would open a write transaction, and
    // the read would take the write lock with nothing to report it.
    func test_that_a_read_survives_being_passed_through_a_generic_parameter() async throws {
        // Given
        func hop<S: DBStorable, T: DBOperation>(
            _ operation: T,
            through storage: S
        ) async throws -> T.Result where T.Transaction == S.Transaction {
            try await storage.run(operation)
        }

        let connection = ProxyConnection<[Int]>([])
        let opened = ProxyConnection<[String]>([])
        let sut = OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        )

        // When
        _ = try await hop(ProxyDBOperation(true) { _, handle in handle.readOnly }, through: sut)
        let reading = try await hop(
            ProxyDBOperation(true, readOnly: true) { _, handle in handle.readOnly },
            through: sut
        )

        // Then
        XCTAssertEqual(opened.value, ["write", "read"])
        XCTAssertTrue(reading)
    }

    // `Parameter` is resolved statically, so the assertion is that
    // `ParameterlessDBOperation` — which declares none — compiles at all. This
    // runs it to keep the double from going unused.
    func test_that_operation_without_a_declared_parameter_runs() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([0, 0])
        let sut: any DBStorable<ProxyConnection<[Int]>> = ProxyDBStorage(
            connect: { connection }
        )

        // When
        let result = try await sut.run(ParameterlessDBOperation())

        // Then
        XCTAssertEqual(result, 2)
    }

    // Reset is the driver's — emptying the database is the same kind of work as
    // creating its schema.
    func test_that_reset_clears_all_data_in_the_driver() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([0])
        let sut = ProxyDBStorage(
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
