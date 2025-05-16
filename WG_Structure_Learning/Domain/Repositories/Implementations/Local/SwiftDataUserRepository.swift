import Foundation
import SwiftData

@MainActor
final class SwiftDataUserRepository {
    private let container: ModelContainer
    private let context: ModelContext
    
    init() {
        do {
            container = try ModelContainer(for: LocalUserModel.self)
            context = container.mainContext
        } catch {
            fatalError("ModelContainer setup failed: \(error)")
        }
    }
    
    func saveUser(_ user: User) throws {
        let localUser = LocalUserModel(id: user.id, email: user.email)
        context.insert(localUser)
        try context.save()
    }
    
    func getCurrentUser() throws -> User? {
        let descriptor = FetchDescriptor<LocalUserModel>()
        let users = try context.fetch(descriptor)
        guard let user = users.first else { return nil }
        return User(id: user.id, email: user.email)
    }
    
    func deleteUser() throws {
        let descriptor = FetchDescriptor<LocalUserModel>()
        let users = try context.fetch(descriptor)
        for user in users {
            context.delete(user)
        }
        try context.save()
    }
} 
