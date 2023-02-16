//
//  SIAddItem.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIAddItem {
    // MARK: - Property
    public let attributes: [any SIAttributes]
    
    // MARK: - Initializer
    public init(
        class: any SIClass,
        value: SIValue
    ) {
        self.attributes = [`class`, value]
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
