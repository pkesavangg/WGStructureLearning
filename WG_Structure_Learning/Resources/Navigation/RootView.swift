import SwiftUI

struct RootView: View {
   private var viewModel = RootViewModel()
    
    var body: some View {
        Group {
            if viewModel.canShowLoader {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isAuthenticated {
                MainTabView()
            } else {
                LandingScreen()
            }
            
        }
    }
}
