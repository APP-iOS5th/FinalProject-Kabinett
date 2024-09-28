//
//  WriteLetterViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import Foundation
import SwiftUI

class ContentWriteViewModel: ObservableObject {
    @Published var texts: [String] = [""]
    
    @Published var currentIndex: Int = 0
    
    func reset() {
        texts = [""]
    }
    
    func createNewLetter() {
        texts.append("")
        currentIndex = texts.count
    }
    
    func deleteLetter() {
        if texts.count > 1 {
            texts.remove(at: currentIndex)
            currentIndex = (texts.count - 1)
        }
    }
}
