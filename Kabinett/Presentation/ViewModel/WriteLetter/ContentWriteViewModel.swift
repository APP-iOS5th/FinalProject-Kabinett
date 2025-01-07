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
    
    @State var showFontMenu: Bool = false
    @State var isFontEdit: Bool = true

    func createNewLetter(idx: Int) {
        texts.insert("", at: idx+1)
    }
    
    func deleteLetter(idx: Int) {
        if texts.count > 1 {
            texts.remove(at: idx)
        }
    }
}
