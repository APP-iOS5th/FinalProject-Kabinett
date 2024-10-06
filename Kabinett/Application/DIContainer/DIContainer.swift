//
//  DIContainer.swift
//  Kabinett
//
//  Created by jinwoong Kim on 10/6/24.
//

import Foundation

final class DIContainer {
    static var shared = DIContainer()
    private var modules: [String: Module] = [:]
    
    private init() {}
    
    deinit { modules.removeAll() }
}

extension DIContainer {
    func register(with module: Module) {
        modules[module.name] = module
    }
    
    func resolve<T>(for type: Any.Type?) -> T {
        let name = type.map { String(describing: $0) } ?? String(describing: T.self)
        if let resolved = modules[name]?.resolved as? T {
            return resolved
        }
        
        guard let dependency = modules[name]?.resolve() as? T else {
            fatalError("dependency \(T.self) not resolved.")
        }
        modules[name]?.resolved = dependency
        
        return dependency
    }
}

extension DIContainer {
    @resultBuilder
    struct ModuleBuilder {
        static func buildBlock(_ components: Module...) -> [Module] {
            components
        }
        static func buildBlock(_ component: Module) -> Module {
            component
        }
    }
    
    func register(@ModuleBuilder _ modules: () -> [Module]) {
        modules().forEach { register(with: $0) }
    }
    
    func register(@ModuleBuilder _ module: () -> Module) {
        register(with: module())
    }
}
