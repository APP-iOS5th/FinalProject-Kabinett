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
    
    func createNewLetter() {
        texts.append("")
        textViewHeights.append(.zero)
    }
}
