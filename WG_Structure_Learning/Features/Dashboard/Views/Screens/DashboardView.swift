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
            }
            .environment(store)
        }
    }
}

#Preview {
    SettingsView()
        .environment(DashboardStore())
}
