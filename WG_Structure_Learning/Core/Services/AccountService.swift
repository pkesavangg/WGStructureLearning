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
    private let httpClient = HTTPClient.shared

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
        // First try Firebase authentication
        let success = try await firebaseRepository.signIn(email: email, password: password)
        if success {
            // Make API call to backend using HTTPClient
            let loginRequest = LoginRequest(email: email, password: password)
            
            do {
                let response: LoginResponse = try await httpClient.send(
                    .login,
                    method: "POST",
                    body: loginRequest
                )
                
                print("API Response:", response)
                
                // Create and save user with the account data
                let user = User(id: response.account.id, email: response.account.email)
                try userRepository.saveUser(user)
                currentUser = user
                return true
            } catch {
                print("API Error:", error)
                throw error
            }
        }
        return false
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

