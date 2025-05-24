import Foundation

@MainActor
@Observable
final class SignupStore {
    @ObservationIgnored
    @Injector private var accountService: AccountService
    
    var isLoading = false
    var error: String?
    var isAuthenticated = false
    
    func signup(request: UserProfile) async {
        isLoading = true
        error = nil
        do {
            let success = try await accountService.createAccount(request)
            if success {
                isAuthenticated = true
            } else {
                error = "Failed to create account"
            }
        } catch {
            self.error = error.localizedDescription
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
}
