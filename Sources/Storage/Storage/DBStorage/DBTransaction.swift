//
//  DBTransaction.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation

public protocol DBTransaction: Sendable {
    associatedtype Connection
    /// The transaction's input type. No requirement names it, so it can never be
    /// inferred — without a default every conformer, including one that takes
    /// nothing, has to spell it out.
    associatedtype Parameter = Never
    associatedtype Result
    
    @discardableResult
    func execute(_ connection: Connection) async throws -> Result
}
