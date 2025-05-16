import SwiftUI

@MainActor
final class SettingsStore: ObservableObject {
    @Injector private var accountService: AccountService
    
    @Published var isDarkMode = false
    @Published var notificationsEnabled = true
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    func signOut() async {
        do {
            try await accountService.signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
} 
