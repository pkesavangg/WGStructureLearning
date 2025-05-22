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
    var allAccounts: [AccountModel] = []

    private let userRepository = SwiftDataUserRepository()
    private let authRepository = AuthRepository()

    var isAuthenticated: Bool {
        return currentUser != nil
    }

    init() {
        do {
            try loadCurrentUser()
            try loadAllAccounts()
        } catch {
            print("Failed to load current user:", error)
        }
    }
    
    func login(email: String, password: String) async throws -> Bool {
        do {
            let response = try await authRepository.login(email: email, password: password)
            // Create and save auth user with the response data
            let authUser = AccountModel(from: response)
            try userRepository.saveAuthUser(authUser)
            currentUser = authUser
            try loadAllAccounts()
            return true
        } catch {
            throw error
        }
    }
    
    func createAccount(_ data: SignupRequest) async throws -> Bool {
        do {
            let response = try await authRepository.createAccount(requestData: data)
            let authUser = AccountModel(from: response)
            try userRepository.saveAuthUser(authUser)
            currentUser = authUser
            try loadAllAccounts()
            return true
        } catch {
            throw error
        }
    }
    
    func updateUserProfile() async throws {
        guard currentUser != nil  else { return }
        
        do {
            let response = try await authRepository.updateAccount()
            // Update the current user with new data
            let updatedAuthUser = AccountModel(from: response)
            try userRepository.updateAuthUser(updatedAuthUser)
            self.currentUser = updatedAuthUser
            try loadAllAccounts()
        } catch {
            print("Failed to update user profile:", error)
            throw error
        }
    }

    func loadCurrentUser() throws {
        currentUser = try userRepository.getCurrentAuthUser()
    }
    
    func loadAllAccounts() throws {
        allAccounts = try userRepository.getAllAccounts()
    }
    
    func switchAccount(to accountId: String) throws {
        try userRepository.switchAccount(to: accountId)
        try loadCurrentUser()
    }

    func signOut() async throws {
        try await authRepository.logout()
        try userRepository.logout() // This will only set isLogin to false
        currentUser = nil
        try loadAllAccounts() // Reload accounts to update the list
    }
    
    func deleteAccount() async throws {
        guard let currentUser = currentUser else { return }
        try await authRepository.deleteAccount()
        try userRepository.deleteAccount(accountId: currentUser.id)
        self.currentUser = nil
        try loadAllAccounts()
    }
}

