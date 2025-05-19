//
//  NetworkMonitor.swift
//  ModalViewLearningArc
//
//  Created by Kesavan Panchabakesan on 13/04/25.
//


import Network
import Foundation
import Combine
import SwiftUI

@Observable
@MainActor
final class NetworkMonitor {
    static let shared = NetworkMonitor()
    let notificationHelper = NotificationHelperManager.shared

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var networkState: NetworkState = .connected

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let connected = path.status == .satisfied
                self.networkState = connected ? .connected : .disconnected

                if !connected {
                    self.notificationHelper.showToast("No Internet Connection 😢", duration: 99999)
                } else {
                    self.notificationHelper.isToastVisible = false // hide toast on reconnect
                }
            }
        }
        monitor.start(queue: queue)
    }
}
