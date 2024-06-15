//
//  SIMatchItem.swift
//  
//
//  Created by JSilver on 2023/02/15.
//

import Foundation

public struct SIMatchItem {
    // MARK: - Property
    public let attributes: [any SIAttributes]
    
    // MARK: - Initializer
    public init(
        queries: [any SIAttributes],
        return: SIReturn
    ) {
        self.attributes = queries + [`return`]
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
