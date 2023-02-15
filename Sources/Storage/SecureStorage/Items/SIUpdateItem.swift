//
//  SIUpdateItem.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIUpdateItem {
    // MARK: - Property
    let query: CFDictionary
    let attributes: CFDictionary
    
    // MARK: - Initializer
    public init(
        queries: [any SIAttributes],
        values: [any SIAttributes]
    ) {
        query = Dictionary<String, Any>(
            uniqueKeysWithValues: queries.flatMap { $0.attributes }
                .map { ($0, $1) }
        ) as CFDictionary
        
        attributes = Dictionary<String, Any>(
            uniqueKeysWithValues: values.flatMap { $0.attributes }
                .map { ($0, $1) }
        ) as CFDictionary
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
