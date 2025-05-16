//
//  DashboardView.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 16/05/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var store = DashboardStore()
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to the Dashboard")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: SettingsView().environmentObject(store)) {
                    Text("Go to Settings")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button("Logout") {
                    store.logout()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}


struct SettingsView: View {
    @EnvironmentObject var store: DashboardStore
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
            
            Button("Logout") {
                store.logout()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

