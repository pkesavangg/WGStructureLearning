import SwiftUI

struct RootView: View {
   private var viewModel = RootViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginScreen()
            }
        }
    }
}
