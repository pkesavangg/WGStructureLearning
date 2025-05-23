import SwiftUI
import Foundation

@MainActor
final class SettingsStore: ObservableObject {
    @Injector private var accountService: AccountService
    
    // We'll use a mock for the account data since we're having import issues
    @Published var isDarkMode = false
    @Published var notificationsEnabled = true
    @Published var isUpdatingProfile = false
    @Published var profileUpdateError: String? = nil
    
    // Mock user data based on the sample provided
    @Published var firstName = "g"
    @Published var lastName = "P"
    @Published var email = "pkesavan@greatergoods.com"
    @Published var dob = Date(timeIntervalSince1970: 907372800) // 1998-10-03
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    func signOut() async {
        self.isUpdatingProfile = true
        do {
            try await accountService.signOut()
        } catch  {
            print("Error signing out: \(error)")
        }
    }
    
    func updateUserProfile(firstName: String, lastName: String, dob: Date) async {
        isUpdatingProfile = true
        profileUpdateError = nil
        
        do {
            // Call the account service to update the profile
            try await accountService.updateUserProfile(firstName: firstName, lastName: lastName, dob: dob)
            
            // Update local properties after successful API call
            self.firstName = firstName
            self.lastName = lastName
            self.dob = dob
            
            isUpdatingProfile = false
        } catch {
            // Handle any errors
            profileUpdateError = error.localizedDescription
            print("Error updating profile updateUserProfile: \(error)")
            isUpdatingProfile = false
        }
    }
    func deleteAccount() async -> Bool {
        isUpdatingProfile = true
        do {
            try await accountService.deleteAccount()
            isUpdatingProfile = false
            return true
        } catch {
            print("Error deleting account: \(error)")
            profileUpdateError = error.localizedDescription
            isUpdatingProfile = false
            return false
        }
    }
} 
