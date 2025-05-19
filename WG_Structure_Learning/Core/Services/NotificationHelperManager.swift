//
//  UIFeedbackManager.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//

// MARK: - Loader Messages
struct LoaderStrings {
    static let loading = "Loading..."
    static let saving = "Saving..."
    static let deleting = "Deleting..."
    static let loggingIn = "Logging in..."
    static let uploading = "Uploading..."
    static let sending = "Sending..."
    static let updating = "Updating..."
}


import Foundation
import SwiftUI

@Observable
@MainActor
final class NotificationHelperManager {
    static let shared = NotificationHelperManager()

    // Loader State
    var loaderMessage: String = LoaderStrings.loading
    var isLoaderVisible: Bool = false

    // Toast State
    var toastMessage: String = ""
    var isToastVisible: Bool = false

    private init() {}

    // MARK: - Loader Methods
    func showLoader(message: String = LoaderStrings.loading) {
        self.loaderMessage = message
        self.isLoaderVisible = true
    }

    func hideLoader() {
        self.isLoaderVisible = false
        self.loaderMessage = LoaderStrings.loading // Reset to default
    }

    // MARK: - Toast Methods
    func showToast(_ message: String, duration: TimeInterval = 2.0) {
        self.toastMessage = message
        self.isToastVisible = true

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isToastVisible = false
            self.toastMessage = ""
        }
    }
}
