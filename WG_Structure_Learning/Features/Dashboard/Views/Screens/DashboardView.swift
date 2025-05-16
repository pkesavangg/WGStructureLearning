//
//  DashboardView.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 16/05/25.
//

import SwiftUI

struct DashboardView: View {
    var store = DashboardStore()
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to the Dashboard")
                    .font(.title)
                    .padding()

                
                Button("Logout") {
                    store.logout()
                }
                .buttonStyle(.borderedProminent)
            }
            .environment(store)
        }
    }
}



struct SettingsView: View {
    @Environment(DashboardStore.self) var store
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
            
            Button {
                store.logout()
            } label: {
                Text("Logout")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(DashboardStore())
}
