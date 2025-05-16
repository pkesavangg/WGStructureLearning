import Foundation

@MainActor
@Observable
final class LoginStore {
    @ObservationIgnored
    @Injector private var accountService: AccountService
    var email = ""
    var password = ""
    var rememberMe = false
    var isLoading = false
    var error: String?
    var isAuthenticated = false

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


