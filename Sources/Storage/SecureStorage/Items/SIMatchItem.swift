//
//  SIMatchItem.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIMatchItem {
    // MARK: - Property
    let attributes: CFDictionary
    
    // MARK: - Initializer
    public init(
        queries: [any SIAttributes],
        return: SIReturn
    ) {
        let attributes: [any SIAttributes] = queries + [`return`]
        self.attributes = Dictionary<String, Any>(
            uniqueKeysWithValues: attributes
                .compactMap { $0 }
                .flatMap { $0.attributes }
                .map { ($0, $1) }
        ) as CFDictionary
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
