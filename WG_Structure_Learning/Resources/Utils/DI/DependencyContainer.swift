//
//  DependencyContainer.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 15/05/25.
//

import SwiftUI

class DependencyContainer {
    static let shared = DependencyContainer()

    var dependencies: [String: Any] = [:]

    func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency
    }

    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: T.self)
        return dependencies[key] as? T
    }
}

@propertyWrapper
struct Injector<Value> {
    private var value: Value?

    init() {}

    var wrappedValue: Value {
        mutating get {
            if value == nil {
                value = DependencyContainer.shared.resolve(Value.self)
            }
            return value!
        }
        set {
            value = newValue
        }
    }

    var projectedValue: Injector<Value> {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
}
