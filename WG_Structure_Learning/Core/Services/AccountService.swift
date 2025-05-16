//
//  AccountService.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 15/05/25.
//
import Foundation

@MainActor
@Observable
final class AccountService {
    static let shared = AccountService()
    var currentUser: User? = nil

    private let userRepository = SwiftDataUserRepository()
    private let firebaseRepository = FirebaseAuthRepository()

    var isAuthenticated: Bool {
        return currentUser != nil
    }

    init() {
        do {
            try loadCurrentUser()
        } catch  {
            
        }
    }
    
    func signIn(email: String, password: String) async throws -> Bool {
        let success = try await firebaseRepository.signIn(email: email, password: password)
        if success {
            let user = User(id: UUID().uuidString, email: email)
            try userRepository.saveUser(user)
            currentUser = user
        }
        print(currentUser?.email ?? "No user found", " current user")
        return success
    }

    func loadCurrentUser() throws {
        if let savedUser = try userRepository.getCurrentUser() {
            currentUser = savedUser
        }
    }

    func signOut() async throws {
        try await firebaseRepository.signOut()
        try userRepository.deleteUser()
        currentUser = nil
    }
}

