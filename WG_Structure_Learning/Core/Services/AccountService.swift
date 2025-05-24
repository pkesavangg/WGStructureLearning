//
//  AccountService.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 15/05/25.
//
import Foundation
import SwiftData

extension Array where Element == AccountModel {
    func toAccounts() -> [Account] {
        return self.map { $0.toAccount() }
    }
}


@MainActor
@Observable
final class AccountService {
    static let shared = AccountService()
    var currentUser: Account? = nil
    var allAccounts: [Account] = []

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
            currentUser = response
            try loadAllAccounts()
            return true
        } catch {
            throw error
        }
    }
    
    func createAccount(_ data: UserProfile) async throws -> Bool {
        do {
            let response = try await authRepository.createAccount(requestData: data)
            let authUser = AccountModel(from: response)
            try userRepository.saveAuthUser(authUser)
            currentUser = response
            try loadAllAccounts()
            return true
        } catch {
            throw error
        }
    }
    
    func updateUserProfile(firstName: String, lastName: String, dob: Date) async throws {
        guard let currentUser = currentUser else { return }
        
        do {
            // Format the date to string in ISO8601 format
            let formatter = ISO8601DateFormatter()
            let dobString = formatter.string(from: dob)
            
            // Create the request with the updated profile data
            let request = UserProfile(
                email: currentUser.account.email,
                password: nil, // or fetch securely if needed
                firstName: firstName,
                lastName: lastName.isEmpty ? " " : lastName,
                gender: currentUser.account.gender.rawValue,
                zipcode: currentUser.account.zipcode,
                dob: dobString,
                height: currentUser.account.height ?? 0,
                device: nil // provide if you want to track device info
            )
            
            // Make the API call to update the account
            let response = try await authRepository.updateAccount(updateData: request)
            
            // Create a new Account object that preserves the tokens from the current user
            // if they're not present in the response
            let preservedResponse = Account(
                account: response.account,
                accessToken: response.accessToken ?? currentUser.accessToken,
                refreshToken: response.refreshToken ?? currentUser.refreshToken,
                expiresAt: response.expiresAt ?? currentUser.expiresAt
            )
            
            // Update the current user with new data from the response
            let updatedAuthUser = AccountModel(from: preservedResponse)
            try userRepository.saveAuthUser(updatedAuthUser)
            self.currentUser = preservedResponse
            try loadAllAccounts()
        } catch {
            print("Failed to update user profile:", error)
            throw error
        }
    }

    func loadCurrentUser() throws {
        if let accountModel = try userRepository.getCurrentAuthUser() {
            currentUser = accountModel.toAccount()
        } else {
            currentUser = nil
        }
    }

    func loadAllAccounts() throws {
        let models = try userRepository.getAllAccounts()
        allAccounts = models.toAccounts()
    }
    
    func switchAccount(to accountId: String) throws {
        try userRepository.switchAccount(to: accountId)
        try loadCurrentUser()
    }

    func signOut() async throws {
        do {
            try await authRepository.logout()
            try userRepository.logout() // This will only set isLogin to false
            currentUser = nil
            try loadAllAccounts() // Reload accounts to update the list
        } catch {
            print(error, "Error in signOut")
            throw error
        }
    }
    
    func deleteAccount() async throws {
        guard let currentUser = currentUser else { return }
        try await authRepository.deleteAccount()
        try userRepository.deleteAccount(accountId: currentUser.account.id)
        self.currentUser = nil
        try loadAllAccounts()
    }
}

