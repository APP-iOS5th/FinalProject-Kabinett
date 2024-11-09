//
//  Injected.swift
//  Kabinett
//
//  Created by jinwoong Kim on 10/6/24.
//

import Foundation

/// `Injected`
@propertyWrapper
final class Injected<Value> {
    private var storage: Value
    
    var wrappedValue: Value {
        storage
    }
    
    init<K>(_ key: K.Type) where K: InjectionKey, Value == K.Value {
        storage = key.currentValue
    }
}
