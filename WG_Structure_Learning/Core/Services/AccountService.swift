//
//  AccountService.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 15/05/25.
//
import Foundation
import SwiftData

@MainActor
@Observable
final class AccountService {
    static let shared = AccountService()
    var currentUser: AccountModel? = nil

    private let userRepository = SwiftDataUserRepository()
    private let firebaseRepository = FirebaseAuthRepository()
    private let httpClient = HTTPClient.shared

    var isAuthenticated: Bool {
        return currentUser != nil
    }

    init() {
        do {
            try loadCurrentUser()
        } catch {
            print("Failed to load current user:", error)
        }
    }
    
    func signIn(email: String, password: String) async throws -> Bool {
        // First try Firebase authentication
        let success = try await firebaseRepository.signIn(email: email, password: password)
        if success {
            // Make API call to backend using HTTPClient
            let loginRequest = LoginRequest(email: email, password: password)
            
            do {
                let response: Account = try await httpClient.send(
                    .login,
                    method: "POST",
                    body: loginRequest
                )
                // Create and save auth user with the response data
                let authUser = AccountModel(from: response)
                try userRepository.saveAuthUser(authUser)
                currentUser = authUser
                return true
            } catch {
                print("API Error:", error)
                throw error
            }
        }
        return false
    }
    
    func updateUserProfile() async throws {
        guard let currentUser = currentUser else { return }
        
        do {
//            let response: UserResponse = try await httpClient.send(
//                .getAccount,
//                method: "GET"
//            )
//            
//            // Update the current user with new data
//            let updatedAuthUser = AuthUserModel(from: LoginResponse(
//                account: response,
//                accessToken: currentUser.accessToken,
//                refreshToken: currentUser.refreshToken,
//                expiresAt: currentUser.expiresAt
//            ))
//            
//            try userRepository.updateAuthUser(updatedAuthUser)
//            self.currentUser = updatedAuthUser
        } catch {
            print("Failed to update user profile:", error)
            throw error
        }
    }

    func loadCurrentUser() throws {
        if let savedUser = try userRepository.getCurrentAuthUser() {
            currentUser = savedUser
        }
    }

    func signOut() async throws {
        try await firebaseRepository.signOut()
        try userRepository.deleteAuthUser()
        currentUser = nil
    }
}

