import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                DashboardView()
            } else {
                LoginScreen()
            }
        }
    }
} 
