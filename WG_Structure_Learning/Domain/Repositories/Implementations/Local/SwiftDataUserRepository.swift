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
            // Use the simplest form for now to avoid conflicts
            container = try ModelContainer(for: AccountModel.self)
            context = container.mainContext
        } catch {
            fatalError("ModelContainer setup failed: \(error)")
        }
    }
    
    func saveAuthUser(_ authUser: AccountModel) throws {
        // Check if account already exists
        let emailToCheck = authUser.email
        let descriptor = FetchDescriptor<AccountModel>(
            predicate: #Predicate { $0.email == emailToCheck }
        )

        let existingUsers = try context.fetch(descriptor)
        
        if let existingUser = existingUsers.first {
            // Update existing user's data
            existingUser.firstName = authUser.firstName
            existingUser.lastName = authUser.lastName
            existingUser.gender = authUser.gender
            existingUser.zipcode = authUser.zipcode
            existingUser.weightUnit = authUser.weightUnit
            existingUser.isWeightlessOn = authUser.isWeightlessOn
            existingUser.preferredInputMethod = authUser.preferredInputMethod
            existingUser.height = authUser.height
            existingUser.activityLevel = authUser.activityLevel
            existingUser.dob = authUser.dob
            existingUser.weightlessBodyFat = authUser.weightlessBodyFat
            existingUser.weightlessMuscle = authUser.weightlessMuscle
            existingUser.weightlessTimestamp = authUser.weightlessTimestamp
            existingUser.weightlessWeight = authUser.weightlessWeight
            existingUser.isStreakOn = authUser.isStreakOn
            existingUser.dashboardType = authUser.dashboardType
            existingUser.dashboardMetrics = authUser.dashboardMetrics
            existingUser.goalType = authUser.goalType
            existingUser.goalWeight = authUser.goalWeight
            existingUser.initialWeight = authUser.initialWeight
            existingUser.shouldSendEntryNotifications = authUser.shouldSendEntryNotifications
            existingUser.shouldSendWeightInEntryNotifications = authUser.shouldSendWeightInEntryNotifications
            existingUser.accessToken = authUser.accessToken
            existingUser.refreshToken = authUser.refreshToken
            existingUser.expiresAt = authUser.expiresAt
            existingUser.isLogin = true
        } else {
            // Set all other accounts to not logged in
            let allUsersDescriptor = FetchDescriptor<AccountModel>()
            let allUsers = try context.fetch(allUsersDescriptor)
            for user in allUsers {
                user.isLogin = false
            }
            
            // Insert new user
            authUser.isLogin = true
            context.insert(authUser)
        }
        
        try context.save()
    }
    
    // Save an additional account without logging out the current user
    func saveAdditionalAccount(_ authUser: AccountModel) throws {
        // Check if account already exists
        let emailToCheck = authUser.email
        let descriptor = FetchDescriptor<AccountModel>(
            predicate: #Predicate { $0.email == emailToCheck }
        )

        let existingUsers = try context.fetch(descriptor)
        
        if let existingUser = existingUsers.first {
            // Update existing user's data
            existingUser.firstName = authUser.firstName
            existingUser.lastName = authUser.lastName
            existingUser.gender = authUser.gender
            existingUser.zipcode = authUser.zipcode
            existingUser.weightUnit = authUser.weightUnit
            existingUser.isWeightlessOn = authUser.isWeightlessOn
            existingUser.preferredInputMethod = authUser.preferredInputMethod
            existingUser.height = authUser.height
            existingUser.activityLevel = authUser.activityLevel
            existingUser.dob = authUser.dob
            existingUser.weightlessBodyFat = authUser.weightlessBodyFat
            existingUser.weightlessMuscle = authUser.weightlessMuscle
            existingUser.weightlessTimestamp = authUser.weightlessTimestamp
            existingUser.weightlessWeight = authUser.weightlessWeight
            existingUser.isStreakOn = authUser.isStreakOn
            existingUser.dashboardType = authUser.dashboardType
            existingUser.dashboardMetrics = authUser.dashboardMetrics
            existingUser.goalType = authUser.goalType
            existingUser.goalWeight = authUser.goalWeight
            existingUser.initialWeight = authUser.initialWeight
            existingUser.shouldSendEntryNotifications = authUser.shouldSendEntryNotifications
            existingUser.shouldSendWeightInEntryNotifications = authUser.shouldSendWeightInEntryNotifications
            existingUser.accessToken = authUser.accessToken
            existingUser.refreshToken = authUser.refreshToken
            existingUser.expiresAt = authUser.expiresAt
            existingUser.isLogin = true
            
            // Set all other accounts to not logged in
            let allUsersDescriptor = FetchDescriptor<AccountModel>(
                predicate: #Predicate { $0.email != emailToCheck }
            )
            let otherUsers = try context.fetch(allUsersDescriptor)
            for user in otherUsers {
                user.isLogin = false
            }
        } else {
            // Set all other accounts to not logged in
            let allUsersDescriptor = FetchDescriptor<AccountModel>()
            let allUsers = try context.fetch(allUsersDescriptor)
            for user in allUsers {
                user.isLogin = false
            }
            
            // Insert new user
            authUser.isLogin = true
            context.insert(authUser)
        }
        
        try context.save()
    }
    
    func getCurrentAuthUser() throws -> AccountModel? {
        let descriptor = FetchDescriptor<AccountModel>(
            predicate: #Predicate<AccountModel> { $0.isLogin == true }
        )
        let users = try context.fetch(descriptor)
        return users.first
    }
    
    func getAllAccounts() throws -> [AccountModel] {
        let descriptor = FetchDescriptor<AccountModel>()
        return try context.fetch(descriptor)
    }
    
    func logout() throws {
        // Just set isLogin to false for the current user
        if let currentUser = try getCurrentAuthUser() {
            currentUser.isLogin = false
            try context.save()
        }
    }
    
    func updateAuthUser(_ authUser: AccountModel) throws {
        try context.save()
    }
    
    func switchAccount(to accountId: String) throws {
        let descriptor = FetchDescriptor<AccountModel>()
        let users = try context.fetch(descriptor)
        
        // Set all accounts to not logged in
        for user in users {
            user.isLogin = false
        }
        
        // Set the selected account as logged in
        if let selectedUser = users.first(where: { $0.id == accountId }) {
            selectedUser.isLogin = true
            try context.save()
        }
    }
    
    func deleteAccount(accountId: String) throws {
        let descriptor = FetchDescriptor<AccountModel>(
            predicate: #Predicate<AccountModel> { $0.id == accountId }
        )
        let users = try context.fetch(descriptor)
        if let user = users.first {
            context.delete(user)
            try context.save()
        }
    }
} 
