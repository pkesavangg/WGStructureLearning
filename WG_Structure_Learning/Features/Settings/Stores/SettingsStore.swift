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
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var dob = Date(timeIntervalSince1970: 907372800) // 1998-10-03
    
    init() {
        // Load user data from the account service
        loadUserData()
    }
    
    private func loadUserData() {
        // Load user data from the account service
        if let user = accountService.currentUser {
            self.firstName = user.account.firstName
            self.lastName = user.account.lastName
            self.email = user.account.email
//            self.dob = user.account.dob
            let formatter = ISO8601DateFormatter()
            if let parsedDate = formatter.date(from: user.account.dob) {
                self.dob = parsedDate
            } else {
                self.dob = Date(timeIntervalSince1970: 0) // fallback value
            }
            print(self.firstName, self.lastName, self.email, self.dob, "User data loaded")
        }
    }
    
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
