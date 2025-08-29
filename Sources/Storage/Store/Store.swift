//
//  Store.swift
//
//
//  Created by jsilver on 2022/02/06.
//

import Foundation
import Combine

@propertyWrapper
public struct Store<Value: Codable> {
    // MARK: - Property
    private let queue = DispatchQueue(label: "com.storage.store")
    
    private let storage: any Storage
    private let key: String
    private let defaultValue: Value
    
    public var wrappedValue: Value {
        get {
            (try? storage.read(forKey: key)) ?? defaultValue
        }
        set {
            let copy = self
            
            queue.sync {
                do {
                    if let _ = try? copy.storage.read(forKey: copy.key) {
                        try copy.storage.update(newValue, forKey: copy.key)
                    } else {
                        try copy.storage.create(newValue, forKey: copy.key)
                    }
                    
                    copy.subject.send(newValue)
                } catch {
                    // Do nothing.
                }
            }
        }
    }
    
    private let subject: CurrentValueSubject<Value, Never>
    public var projectedValue: AnyPublisher<Value, Never> {
        subject.share()
            .eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    public init(_ storage: any Storage, forKey key: String, default value: Value) {
        self.storage = storage
        self.key = key
        self.defaultValue = value
        
        self.subject = CurrentValueSubject((try? storage.read(forKey: key)) ?? value)
    }
    
    // MARK: - Public
    public func reset() throws {
        try storage.delete(forKey: key)
    }
    
    // MARK: - Private
}

public extension Store where Value: ExpressibleByNilLiteral {
    init(_ storage: any Storage, forKey key: String) {
        self.init(storage, forKey: key, default: .init(nilLiteral: Void()))
    }
}
