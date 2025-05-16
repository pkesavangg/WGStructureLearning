import SwiftUI
import Combine

@MainActor
class RootViewModel: ObservableObject {
    @Injector var accountService: AccountService
    @Published var isAuthenticated: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        accountService.$currentUser
            .sink { [weak self] user in
                self?.isAuthenticated = user != nil
            }
            .store(in: &cancellables)
    }
} 