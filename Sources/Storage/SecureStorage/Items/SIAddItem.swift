//
//  SIAddItem.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIAddItem {
    // MARK: - Property
    let attributes: CFDictionary
    
    // MARK: - Initializer
    public init(
        class: any SIClass,
        value: SIValue
    ) {
        let attributes: [any SIAttributes] = [`class`, value]
        self.attributes = Dictionary<String, Any>(
            uniqueKeysWithValues: attributes
                .flatMap { $0.attributes }
                .map { ($0, $1) }
        ) as CFDictionary
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
