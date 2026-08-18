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
    // There is no way to reach a `DB` without going through the driver first,
    // so these two say what `connect` is obliged to have done by the time it
    // hands one back.
    func test_that_connecting_a_db_connects_the_driver() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let driver = ProxyDBStorage(
            connect: {
                connection.value.append(0)
                return connection
            }
        )

        // When
        _ = try await DB.connect(driver)

        // Then
        XCTAssertEqual(connection.value.count, 1)
    }

    func test_that_connecting_a_db_migrates_the_driver() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let driver = ProxyDBStorage(
            connect: { connection },
            migrate: { _ in connection.value.append(0) }
        )

        // When
        _ = try await DB.connect(driver)

        // Then
        XCTAssertEqual(connection.value.count, 1)
    }

    func test_that_operation_is_applied_when_run_on_db() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let sut = try await DB.connect(ProxyDBStorage(connect: { connection }))

        // When
        try await sut.run(ProxyDBOperation(true) { parameter, connection in
            connection.value.append(0)
        })

        // Then
        XCTAssertEqual(connection.value.count, 1)
    }

    func test_that_db_opens_a_write_transaction_for_an_operation() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let opened = ProxyConnection<[String]>([])
        let sut = try await DB.connect(OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        ))

        // When
        let readOnly = try await sut.run(ProxyDBOperation(true) { _, handle in handle.readOnly })

        // Then
        XCTAssertEqual(opened.value, ["write"])
        XCTAssertFalse(readOnly)
    }

    func test_that_db_opens_a_read_transaction_for_a_read_operation() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([])
        let opened = ProxyConnection<[String]>([])
        let sut = try await DB.connect(OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        ))

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
        let sut = try await DB.connect(OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        ))

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
        let sut = try await DB.connect(OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        ))

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
        func hop<T: DBOperation>(
            _ operation: T,
            through db: DB<OverridingDBStorage.Handle>
        ) async throws -> T.Result where T.Transaction == OverridingDBStorage.Handle {
            try await db.run(operation)
        }

        let connection = ProxyConnection<[Int]>([])
        let opened = ProxyConnection<[String]>([])
        let sut = try await DB.connect(OverridingDBStorage(
            connect: { connection },
            opened: { opened.value.append($0) }
        ))

        // When
        let readOnly = try await hop(ProxyDBOperation(true) { _, handle in handle.readOnly }, through: sut)
        _ = readOnly

        let reading = try await hop(
            ProxyDBOperation(true, readOnly: true) { _, handle in handle.readOnly },
            through: sut
        )

        // Then
        XCTAssertEqual(opened.value, ["write", "read"])
        XCTAssertTrue(reading)
    }

    // `Parameter` is resolved statically, so the assertion is that
    // `ParameterlessDBOperation` — which declares `Never` — compiles at all.
    // This runs it to keep the double from going unused.
    func test_that_operation_taking_nothing_declares_it_and_runs() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([0, 0])
        let sut = try await DB.connect(ProxyDBStorage(connect: { connection }))

        // When
        let result = try await sut.run(ParameterlessDBOperation())

        // Then
        XCTAssertEqual(result, 2)
    }

    // Reset is the driver's, not the db's — emptying the database is the same
    // kind of work as creating its schema, and neither is something a caller
    // handed a `DB` gets to do.
    func test_that_reset_clears_all_data_in_the_driver() async throws {
        // Given
        let connection = ProxyConnection<[Int]>([0])
        let driver = ProxyDBStorage(
            connect: { connection },
            reset: { _ in connection.value.removeAll() }
        )
        try await driver.initialize()

        // When
        try await driver.reset()

        // Then
        XCTAssertEqual(connection.value.count, 0)
    }
}
