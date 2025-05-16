import SwiftUI

struct LoginForm: View {
    @State private var formConfig = LoginFormConfig()
    let onLogin: (String, String) -> Void
    let onForgotPassword: () -> Void
    let onSignUp: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            AuthTextField(
                title: "Email",
                placeholder: "Enter your email",
                text: $formConfig.email,
                keyboardType: .emailAddress
            )
            
            AuthTextField(
                title: "Password",
                placeholder: "Enter your password",
                text: $formConfig.password,
                isSecure: true
            )
            
            HStack {
                Spacer()
                
                Button("Forgot Password?") {
                    onForgotPassword()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            Button(action: {
                if formConfig.isValid {
                    onLogin(formConfig.email, formConfig.password)
                }
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(formConfig.isValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!formConfig.isValid)
            .padding(.horizontal)
            
            if let error = formConfig.validationErrorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 4)
            }
            
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
