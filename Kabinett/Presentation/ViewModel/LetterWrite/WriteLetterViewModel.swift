//
//  WriteLetterViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import Foundation
import SwiftUI

class WriteLetterViewModel: ObservableObject {
    @Published var texts: [String] = [""]
    @Published var textViewHeights: [CGFloat] = [CGFloat](repeating: .zero, count: 1)
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    func createNewLetter(idx: Int) {
        texts.insert("", at: idx+1)
        textViewHeights.insert(.zero, at: idx+1)
    }
}
