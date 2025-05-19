//
//  ToastView.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//


import SwiftUI

struct ToastView: View {
    @Environment(NotificationHelperManager.self) var toastManager
    var body: some View {
        if toastManager.isToastVisible {
            VStack {
                Text(toastManager.toastMessage)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 60)
                    .edgesIgnoringSafeArea(.all)
                Spacer()
            }
        }
    }
}

#Preview {
    let toastManager = NotificationHelperManager.shared
    toastManager.showToast("🔔 This is a toast message!", duration: 5)

    return VStack {
        ToastView()
    }
    .environment(toastManager)
}
