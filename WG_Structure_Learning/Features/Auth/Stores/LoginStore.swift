import Foundation

@MainActor
@Observable
final class LoginStore {
    @ObservationIgnored
    @Injector private var accountService: AccountService
    
    var isLoading = false
    var error: String?
    var isAuthenticated = false

    func login(email: String, password: String) async {
        isLoading = true
        error = nil
        do {
            let success = try await accountService.login(email: email, password: password)
            if success {
                isAuthenticated = true
            } else {
                error = "Login failed. Please try again."
            }
        } catch let loginError {
            error = loginError.localizedDescription
        }
        isLoading = false
    }
    
    // Add a new account without logging out the current user
    func addNewAccount(email: String, password: String) async {
        isLoading = true
        error = nil
        do {
            let success = try await accountService.addNewAccount(email: email, password: password)
            if success {
                isAuthenticated = true
            } else {
                error = "Adding account failed. Please try again."
            }
        } catch let addError {
            error = addError.localizedDescription
        }
        isLoading = false
    }

    func checkExistingSession() async {
        do {
            try await accountService.loadCurrentUser()
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


