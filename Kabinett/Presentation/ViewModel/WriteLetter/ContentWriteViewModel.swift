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
    @Published var isDeleteAlertPresented = false
    
    @Published var showFontMenu: Bool = false
    @Published var isFontEdit: Bool = true

    func toggleFontView() {
        showFontMenu.toggle()
    }
    
    func createNewLetter(idx: Int) {
        texts.insert("", at: idx+1)
    }
    
    func deleteLetter(idx: Int) {
        if texts.count > 1 {
            texts.remove(at: idx)
        }
    }
}
