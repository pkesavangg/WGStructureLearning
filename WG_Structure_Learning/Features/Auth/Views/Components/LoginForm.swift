import SwiftUI

struct LoginForm: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var rememberMe: Bool
    let onLogin: () -> Void
    let onForgotPassword: () -> Void
    let onSignUp: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            AuthTextField(
                title: "Email",
                placeholder: "Enter your email",
                text: $email,
                keyboardType: .emailAddress
            )
            
            AuthTextField(
                title: "Password",
                placeholder: "Enter your password",
                text: $password,
                isSecure: true
            )
            
            HStack {
                Toggle("Remember me", isOn: $rememberMe)
                    .font(.subheadline)
                
                Spacer()
                
                Button("Forgot Password?") {
                    onForgotPassword()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            Button(action: onLogin) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            HStack {
                Text("Don't have an account?")
                    .font(.subheadline)
                
                Button("Sign Up") {
                    onSignUp()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
        }
    }
} 