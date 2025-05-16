//
//  DependencyService.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 15/05/25.
//

@MainActor
class DependencyService {
    static let shared = DependencyService()
    
    init() {
        registerService()
    }
    
    @MainActor private func registerService() {
        DependencyContainer.shared.register(AccountService())
    }
    
    nonisolated private func deRegisterServices() {
        DependencyContainer.shared.dependencies.removeValue(forKey: String(describing: AccountService.self))
    }

    
    deinit {
        self.deRegisterServices()
    }
}

