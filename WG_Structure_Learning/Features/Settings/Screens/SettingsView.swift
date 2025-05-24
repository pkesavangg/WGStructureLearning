import SwiftUI

struct SettingsView: View {
   @StateObject var viewModel = SettingsStore()
   @StateObject var router: Router<SettingsRoute> = .init()
   
   // State for delete account confirmation alert
   @State private var showDeleteAccountAlert = false
   @State private var isDeleting = false
   @State private var showDeleteResultAlert = false
   @State private var deleteResultMessage = ""
   
   // State for account switching
   @State private var showAccountSwitcher = false

    var body: some View {
        RoutingView(stack: $router.stack) {
            List {
                Section("Account") {
                    // Account switcher button
                    Button(action: {
                        showAccountSwitcher = true
                    }) {
                        HStack {
                            Text("Switch Account")
                            Spacer()
                            Image(systemName: "person.crop.circle.badge.plus")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Button("Go to Profile") {
                        router.navigate(to: .profile)
                    }

                    Button("Sign Out") {
                        Task {
                            await viewModel.signOut()
                        }
                    }
                    .foregroundColor(.red)
                    
                    Button("Delete Account") {
                        showDeleteAccountAlert = true
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
        // Show account switcher sheet
        .sheet(isPresented: $showAccountSwitcher) {
            AccountSwitcherView()
                .environmentObject(viewModel)
        }
        // Handle login/signup navigation when returning from account switcher
        .onChange(of: viewModel.selectedAccountAction) { action in
            if let action = action {
                switch action {
                case .login:
                    // Navigate to login screen for adding a new account
                    router.navigate(to: .addAccount)
                case .signup:
                    // Navigate to signup screen (for now, using the same login screen)
                    router.navigate(to: .addAccount)
                }
                // Reset the selected action
                viewModel.selectedAccountAction = nil
            }
        }
        // Delete account confirmation alert
        .alert("Delete Account", isPresented: $showDeleteAccountAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    isDeleting = true
                    let success = await viewModel.deleteAccount()
                    isDeleting = false
                    
                    // Show result alert
                    if success {
                        deleteResultMessage = "Your account has been successfully deleted."
                    } else {
                        deleteResultMessage = "Failed to delete account: \(viewModel.profileUpdateError ?? "Unknown error")"
                    }
                    showDeleteResultAlert = true
                }
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
        // Result alert
        .alert("Account Deletion", isPresented: $showDeleteResultAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(deleteResultMessage)
        }
        // Show loading indicator during deletion
        .overlay {
            if isDeleting {
                ZStack {
                    Color.black.opacity(0.4)
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .tint(.white)
                        
                        Text("Deleting account...")
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}
