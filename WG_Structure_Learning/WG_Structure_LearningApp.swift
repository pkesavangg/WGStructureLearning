//
//  WG_Structure_LearningApp.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 15/05/25.
//

import SwiftUI

@main
struct WG_Structure_LearningApp: App {
    let dependencyService = DependencyService.shared
    let themeManager = ThemeManager.shared
    let notificationHelperManager = NotificationHelperManager.shared
    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                LoaderView()
            }
            .themeable()
            .environmentObject(themeManager)
            .environment(notificationHelperManager)
        }
    }
}
