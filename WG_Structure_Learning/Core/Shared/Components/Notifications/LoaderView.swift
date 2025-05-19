//
//  LoaderView.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//


import SwiftUI

struct LoaderView: View {
    @Environment(NotificationHelperManager.self) var loaderManager
    @Environment(\.appTheme) private var theme
    
    var body: some View {
        if loaderManager.isLoaderVisible {
            ZStack {
                // Full screen semi-transparent overlay to block interactions
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                // Loader container
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(theme.primary)
                    
                    Text(loaderManager.loaderMessage)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(theme.onSurface)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(24)
                .background(theme.surface)
                .cornerRadius(.medium)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.2), value: loaderManager.isLoaderVisible)
            .accentColor(theme.primary)
        }
    }
}

#Preview {
    let loaderManager = NotificationHelperManager.shared
    var theme = ThemeManager.shared
    
    loaderManager.showLoader(message: "Loading your data...")
    
    return ZStack {
        Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
        Text("Content behind loader")
        LoaderView()
    }
    .environment(loaderManager)
    .environmentObject(ThemeManager.shared)
}
