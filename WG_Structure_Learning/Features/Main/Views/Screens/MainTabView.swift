import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Explore")
                .tabItem {
                    Label("Explore", systemImage: "safari.fill")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet.clipboard")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
} 
