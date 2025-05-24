import Foundation

struct SignupFormConfig {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var gender: String = "male" // Default value
    var zipcode: String = ""
    var dob: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date() // Default to 18 years ago
    var height: Double = 170.0 // Default height in cm
    
    var isEmailValid: Bool {
        FormValidator.isValidEmail(email)
    }
    
    var isPasswordValid: Bool {
        password.count >= 6 // Minimum 6 characters
    }
    
    var doPasswordsMatch: Bool {
        password == confirmPassword
    }
    
    var isFirstNameValid: Bool {
        !FormValidator.isEmpty(firstName)
    }
    
    var isValid: Bool {
        isEmailValid && 
        isPasswordValid && 
        doPasswordsMatch && 
        isFirstNameValid
    }
    
    var validationErrorMessage: String? {
        if FormValidator.isEmpty(email) {
            return "Email is required"
        } else if !isEmailValid {
            return "Invalid email format"
        } else if FormValidator.isEmpty(password) {
            return "Password is required"
        } else if !isPasswordValid {
            return "Password must be at least 6 characters"
        } else if FormValidator.isEmpty(confirmPassword) {
            return "Please confirm your password"
        } else if !doPasswordsMatch {
            return "Passwords do not match"
        } else if FormValidator.isEmpty(firstName) {
            return "First name is required"
        } else {
            return nil
        }
    }
    
    func toSignupRequest() -> UserProfile {
        // Format date to string in YYYY-MM-DD format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dobString = dateFormatter.string(from: dob)
        
        return UserProfile(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName.isEmpty ? " " : lastName,
            gender: gender,
            zipcode: zipcode.isEmpty ? " " : zipcode,
            dob: dobString,
            height: height,
            device: nil
        )
    }
}
