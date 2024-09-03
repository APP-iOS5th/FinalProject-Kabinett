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
    
    func reset() {
        texts = [""]
        textViewHeights = [CGFloat](repeating: .zero, count: 1)
    }
    
    func createNewLetter() {
        texts.append("")
        textViewHeights.append(.zero)
    }
    
    func selectedFont(font: String) -> UIFont {
        if font == "SFMONO" {
            return UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        } else {
            return UIFont(name: font, size: 15) ?? UIFont.systemFont(ofSize: 15)
        }
    }
}
