import Foundation
import SwiftUI
import SwiftData

@MainActor
final class LoginStore: ObservableObject {
    @Injector private var accountService: AccountService
    @Published var email = ""
    @Published var password = ""
    @Published var rememberMe = false
    @Published var isLoading = false
    @Published var error: String?
    @Published var isAuthenticated = false

    func login() async {
        isLoading = true
        error = nil
        do {
            let success = try await accountService.signIn(email: email, password: password)
            if success {
                isAuthenticated = true
            } else {
                error = "Invalid credentials"
            }
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func checkExistingSession() {
        do {
            try accountService.loadCurrentUser()
            isAuthenticated = accountService.isAuthenticated
        } catch {
            isAuthenticated = false
        }
    }

    func logout() async {
        do {
            try await accountService.signOut()
            isAuthenticated = false
        } catch {
            // Handle logout failure
        }
    }
}

