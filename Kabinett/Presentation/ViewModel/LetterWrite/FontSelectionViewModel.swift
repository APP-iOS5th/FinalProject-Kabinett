//
//  FontViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/19/24.
//

import Foundation
import SwiftUI
import Combine

extension Font {
    static let SFDisplay: Font = .system(size: 14)
    static let SFMONO: Font = .system(size: 14, design: .monospaced)
    static let Goorm: Font = .custom("Groom", size: 14)
    static let Baskervville: Font = .custom("Baskervville", size: 14)
    static let Pecita: Font = .custom("Pecita", size: 14)
}

struct Fonts: Identifiable {
    let id = UUID()
    var fontName: String
    var fileName: Font
}

class FontSelectionViewModel: ObservableObject {
    @Published var dummyFonts: [Fonts] = [
        Fonts(fontName: "SF Display", fileName: .SFDisplay),
        Fonts(fontName: "SF MONO", fileName: .SFMONO),
        Fonts(fontName: "구름 산스 코드", fileName: .Goorm),
        Fonts(fontName: "Baskervville", fileName: .Baskervville),
        Fonts(fontName: "Pecita", fileName: .Pecita),
    ]
    
    @Published var testFontText: [String] = []
    
    init() {
        updateText()
    }
    
    private func updateText() {
        for _ in 0..<dummyFonts.count {
            testFontText.append("")
        }
    }
    
    @Published var selectedIndex: Int = 0
    
    func isSelected(index: Int) -> Bool {
        return selectedIndex == index
    }
}
