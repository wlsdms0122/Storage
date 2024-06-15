//
//  Collection+SIAttributes.swift
//  
//
//  Created by JSilver on 2023/02/16.
//

import Foundation

extension Collection where Element == any SIAttributes {
    var cfDictionary: CFDictionary {
        Dictionary(
            uniqueKeysWithValues: self
                .flatMap { $0.attributes }
                .map { ($0, $1) }
        ) as CFDictionary
    }
}
