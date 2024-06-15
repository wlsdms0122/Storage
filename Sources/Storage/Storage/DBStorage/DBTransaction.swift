//
//  DBTransaction.swift
//
//
//  Created by jsilver on 6/15/24.
//

import Foundation

public protocol DBTransaction {
    associatedtype Connection
    associatedtype Parameter
    associatedtype Result
    
    @discardableResult
    func execute(_ connection: Connection) async throws -> Result
}
