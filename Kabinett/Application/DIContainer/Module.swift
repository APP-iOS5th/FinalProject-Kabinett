//
//  Module.swift
//  Kabinett
//
//  Created by jinwoong Kim on 10/6/24.
//

import Foundation

/// `Module`
final class Module {
    let name: String
    let resolve: () -> Any
    var resolved: Any? = nil
    
    init<T: InjectionKey>(_ name: T.Type, _ resolve: @escaping () -> Any) {
        self.name = String(describing: name)
        self.resolve = resolve
    }
}
