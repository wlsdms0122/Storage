//
//  SIDeleteItem.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIDeleteItem {
    // MARK: - Property
    let query: CFDictionary
    
    // MARK: - Initializer
    public init(
        queries: [any SIAttributes]
    ) {
        query = Dictionary<String, Any>(
            uniqueKeysWithValues: queries.flatMap { $0.attributes }
                .map { ($0, $1) }
        ) as CFDictionary
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
