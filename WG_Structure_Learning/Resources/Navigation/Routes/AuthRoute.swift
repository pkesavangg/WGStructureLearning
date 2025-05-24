import SwiftUI

enum AuthRoute: Routable {
    case login
    case signup
    
    var body: some View {
        switch self {
        case .login:
            LoginScreen()
        case .signup:
            SignupScreen()
        }
    }
}
