import SwiftUI
import SwiftData

struct SignupScreen: View {
    @Bindable var store: SignupStore = SignupStore()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    SignupForm(
                        onSignup: { signupRequest in
                            Task {
                                await store.signup(request: signupRequest)
                            }
                        },
                        onLogin: {
                            // Navigate back to login screen
                            dismiss()
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
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                Text("Back")
            })
            .navigationBarHidden(true)
        }
        .onAppear {
            store.checkExistingSession()
        }
    }
}
