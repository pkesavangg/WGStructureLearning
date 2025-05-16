import SwiftUI

struct SettingsView: View {
   @StateObject var viewModel = SettingsStore()
   @StateObject var router: Router<SettingsRoute> = .init()

    var body: some View {
        RoutingView(stack: $router.stack) {
            List {
                Section("Account") {
                    Button("Go to Profile") {
                        router.navigate(to: .profile)
                    }

                    
                    Button("Sign Out") {
                        Task {
                            await viewModel.signOut()
                        }
                    }
                    .foregroundColor(.red)
                }
                
                Section("Preferences") {
                    Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
                    Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(viewModel.appVersion)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .environmentObject(router)
        .environmentObject(viewModel)
    }
}
