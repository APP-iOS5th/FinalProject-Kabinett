//
//  ToastViewModel.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 2/3/25.
//

import Foundation
import SwiftUI

class ToastViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var showToast: Bool = false
    @Published var backgroundColor: Color = .primary900
    
    init() {
        setupNotification()
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: .showToast,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let message = notification.userInfo?["message"] as? String,
               let color = notification.userInfo?["color"] as? Color {
                self?.showToast(message: message, color: color)
            }
        }
    }
    
    private func showToast(message: String, color: Color) {
        self.message = message
        self.backgroundColor = color
        showToast = true
    }
}
