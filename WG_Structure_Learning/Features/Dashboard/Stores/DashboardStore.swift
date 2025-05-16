//
//  DashboardViewModel.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 16/05/25.
//

import Foundation

@MainActor
@Observable
class DashboardStore {
    @ObservationIgnored
    @Injector private var accountService: AccountService
        
    // Logout
    func logout() {
        Task {
            do {
                try await accountService.signOut()
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
}
