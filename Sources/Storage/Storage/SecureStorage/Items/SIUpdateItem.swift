//
//  SIUpdateItem.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIUpdateItem {
    // MARK: - Property
    public let queries: [any SIAttributes]
    public let attributes: [any SIAttributes]
    
    // MARK: - Initializer
    public init(
        queries: [any SIAttributes],
        values: [any SIAttributes]
    ) {
        self.queries = queries
        self.attributes = values
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
