//
//  LandingScreen.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//

import SwiftUI

struct LandingScreen: View {
    @StateObject private var router = Router<AuthRoute>()
    @Environment(\.appTheme) private var theme
    
    var body: some View {
        RoutingView(stack: $router.stack) {
            ZStack {
                theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Placeholder Logo
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(theme.primary)
                    
                    Text("Welcome")
                        .font(.extraLargeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(theme.onBackground)
                    
                    Text("Sign in or create an account to continue")
                        .font(.subheadline)
                        .foregroundColor(theme.onBackground.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button {
                            router.navigate(to: .login)
                        } label: {
                            Text("Sign In")
                        }
                        .buttonStyle(.auth())
                        
                        Button {
                            router.navigate(to: .signup)
                        } label: {
                            Text("Create Account")
                        }
                        .buttonStyle(.auth(isPrimary: false))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
        .environmentObject(router)
        .themeable()
    }
}

#Preview {
    LandingScreen()
}
