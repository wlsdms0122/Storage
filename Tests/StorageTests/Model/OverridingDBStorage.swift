//
//  OverridingDBStorage.swift
//
//
//  Created by jsilver on 8/17/26.
//

import Foundation
@testable import Storage

/// A storage whose transaction is not its connection, and which separates the
/// read-only one — the shape this abstraction exists for. It records what it
/// opened, so a test can say which kind an operation was given.
final class OverridingDBStorage: DBDriver, DBStorable {
    struct Handle {
        // MARK: - Property
        let readOnly: Bool

        // MARK: - Initializer
        // MARK: - Public
        // MARK: - Private
    }

    // MARK: - Property
    private nonisolated(unsafe) var connection: ProxyConnection<[Int]>?

    private let _connect: @Sendable () throws -> ProxyConnection<[Int]>
    private let _opened: @Sendable (String) -> Void

    // MARK: - Initializer
    init(
        connect: @escaping @Sendable () throws -> ProxyConnection<[Int]>,
        opened: @escaping @Sendable (String) -> Void = { _ in }
    ) {
        self._connect = connect
        self._opened = opened
    }

    // MARK: - Lifecycle
    func initialize() async throws {
        try await migrate(connection: try connect())
    }

    func connect() throws -> ProxyConnection<[Int]> {
        if let connection {
            return connection
        }

        let connection = try _connect()
        self.connection = connection

        return connection
    }

    func migrate(connection: ProxyConnection<[Int]>) async throws { }

    func reset() async throws {
        connection = nil
    }

    func open<T>(readOnly: Bool, _ body: @escaping @Sendable (Handle) throws -> T) async throws -> T {
        _opened(readOnly ? "read" : "write")

        return try body(Handle(readOnly: readOnly))
    }

}
