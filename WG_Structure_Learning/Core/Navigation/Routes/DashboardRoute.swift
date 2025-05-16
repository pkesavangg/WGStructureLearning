//
//  DashboardRoute.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 16/05/25.
//

import SwiftUI

enum SettingsRoute: Routable {
    case profile
    case editProfile
    
    var body: some View {
        switch self {
        case .profile:
            ProfileView()
        case .editProfile:
            EmptyView()
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    
    var body: some View {
        VStack {
            Text(settingsStore.isDarkMode.description)
                .font(.title)
                .padding()
            Text("Profile View")
                .font(.title)
                .padding()
        }

    }
}
