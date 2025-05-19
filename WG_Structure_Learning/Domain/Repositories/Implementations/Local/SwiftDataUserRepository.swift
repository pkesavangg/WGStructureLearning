//
//  SwiftDataUserRepository.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 16/05/25.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataUserRepository {
    private let container: ModelContainer
    private let context: ModelContext
    
    init() {
        do {
            container = try ModelContainer(for: AccountModel.self)
            context = container.mainContext
        } catch {
            fatalError("ModelContainer setup failed: \(error)")
        }
    }
    
    func saveAuthUser(_ authUser: AccountModel) throws {
        context.insert(authUser)
        try context.save()
    }
    
    func getCurrentAuthUser() throws -> AccountModel? {
        let descriptor = FetchDescriptor<AccountModel>()
        let users = try context.fetch(descriptor)
        return users.first
    }
    
    func deleteAuthUser() throws {
        let descriptor = FetchDescriptor<AccountModel>()
        let users = try context.fetch(descriptor)
        for user in users {
            context.delete(user)
        }
        try context.save()
    }
    
    func updateAuthUser(_ authUser: AccountModel) throws {
        try context.save()
    }
} 
