import SwiftUI
import SwiftData

struct LoginScreen: View {
    @Bindable var store: LoginStore = LoginStore()
    @Environment(\.dismiss) private var dismiss
    
    // Flag to indicate if this is for adding a new account
    var isAddingAccount: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    
                    Text(isAddingAccount ? "Add Account" : "Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    
                    LoginForm(
                        onLogin: { email, password in
                            Task {
                                if isAddingAccount {
                                    await store.addNewAccount(email: email, password: password)
                                } else {
                                    await store.login(email: email, password: password)
                                }
                            }
                        },
                        onForgotPassword: {
                            // TODO: Implement forgot password flow
                        },
                        onSignUp: {
                            // TODO: Navigate to sign up screen
                        }
                    )
                    
                    if let error = store.error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 8)
                    }
                    
                    Spacer()
                }
                
                if store.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
            .navigationBarHidden(true)
        }
    }
} 
