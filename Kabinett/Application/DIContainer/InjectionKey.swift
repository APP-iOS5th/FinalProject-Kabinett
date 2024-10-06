//
//  InjectionKey.swift
//  Kabinett
//
//  Created by jinwoong Kim on 10/6/24.
//

import Foundation

protocol InjectionKey {
    associatedtype Value
}

extension InjectionKey {
    static var currentValue: Value {
        DIContainer.shared.resolve(for: Self.self)
    }
}
