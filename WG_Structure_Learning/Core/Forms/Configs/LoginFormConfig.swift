import Foundation

struct LoginFormConfig {
    var email: String = "pkesavan@greatergoods.com"
    var password: String = "123456"
    
    var isEmailValid: Bool {
        FormValidator.isValidEmail(email)
    }
    
    var isPasswordValid: Bool {
        !FormValidator.isEmpty(password)
    }
    
    var isValid: Bool {
        isEmailValid && isPasswordValid
    }
    
    var validationErrorMessage: String? {
        if FormValidator.isEmpty(email) {
            return "Email is required"
        } else if !isEmailValid {
            return "Invalid email format"
        } else if FormValidator.isEmpty(password) {
            return "Password is required"
        } else {
            return nil
        }
    }
} 
