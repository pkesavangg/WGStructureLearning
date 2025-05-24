import SwiftUI

struct SignupForm: View {
    @State private var formConfig = SignupFormConfig()
    let onSignup: (UserProfile) -> Void
    let onLogin: () -> Void
    
    // Gender options
    private let genderOptions = ["male", "female", "other"]
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                VStack(spacing: 15) {
                    // Email field
                    AuthTextField(
                        title: "Email",
                        placeholder: "Enter your email",
                        text: $formConfig.email,
                        keyboardType: .emailAddress
                    )
                    
                    // Password field
                    AuthTextField(
                        title: "Password",
                        placeholder: "Create a password",
                        text: $formConfig.password,
                        isSecure: true
                    )
                    
                    // Confirm Password field
                    AuthTextField(
                        title: "Confirm Password",
                        placeholder: "Confirm your password",
                        text: $formConfig.confirmPassword,
                        isSecure: true
                    )
                    
                    // First Name field
                    AuthTextField(
                        title: "First Name",
                        placeholder: "Enter your first name",
                        text: $formConfig.firstName
                    )
                    
                    // Last Name field
                    AuthTextField(
                        title: "Last Name",
                        placeholder: "Enter your last name (optional)",
                        text: $formConfig.lastName
                    )
                    
                    // Gender selection
                    VStack(alignment: .leading) {
                        Text("Gender")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Picker("Gender", selection: $formConfig.gender) {
                            ForEach(genderOptions, id: \.self) { gender in
                                Text(gender.capitalized).tag(gender)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    }
                    
                    // Zipcode field
                    AuthTextField(
                        title: "Zipcode (optional)",
                        placeholder: "Enter your zipcode",
                        text: $formConfig.zipcode,
                        keyboardType: .numberPad
                    )
                    
                    // Date of Birth picker
                    VStack(alignment: .leading) {
                        Text("Date of Birth")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        DatePicker(
                            "Date of Birth",
                            selection: $formConfig.dob,
                            displayedComponents: .date
                        )
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal)
                    }
                    
                    // Height field
                    VStack(alignment: .leading) {
                        Text("Height (cm)")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack {
                            TextField("Height", value: $formConfig.height, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("cm")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Validation error message
                    if let error = formConfig.validationErrorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 4)
                    }
                    
                    // Sign Up button
                    Button(action: {
                        if formConfig.isValid {
                            onSignup(formConfig.toSignupRequest())
                        }
                    }) {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(formConfig.isValid ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!formConfig.isValid)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Login link
                    HStack {
                        Text("Already have an account?")
                            .font(.subheadline)
                        
                        Button("Login") {
                            onLogin()
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    .padding(.top, 5)
                }
                .padding(.vertical)
            }
        }
    }
}
