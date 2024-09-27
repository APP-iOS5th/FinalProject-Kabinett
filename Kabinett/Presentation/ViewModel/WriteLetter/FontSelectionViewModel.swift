//
//  FontViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/19/24.
//

import Foundation
import SwiftUI
import UIKit

struct Fonts: Identifiable {
    let id = UUID()
    var fontName: String
    var font: String
}

class FontSelectionViewModel: ObservableObject {
    @Published var testFontText: [String] = []
    @Published var selectedIndex: Int = 0
    @Published var showModal: Bool = false
    @Published var dummyFonts: [Fonts] = [
        Fonts(fontName: "SF Display", font: "SFDisplay"),
        Fonts(fontName: "SF MONO", font: "SFMONO"),
        Fonts(fontName: "Source Han Serif 본명조" ,font: "SourceHanSerifK-Regular"),
        Fonts(fontName: "네이버 나눔명조", font: "NanumMyeongjoOTF"),
        Fonts(fontName: "구름 산스 코드", font: "goormSansOTF4"),
        Fonts(fontName: "Baskervville", font: "Baskervville-Regular"),
        Fonts(fontName: "Pecita", font: "Pecita"),
    ]
    
    init() {
        updateText()
    }
    
    func reset() {
        selectedIndex = 0
        testFontText = []
        updateText()
    }
    
    private func updateText() {
        for _ in 0..<dummyFonts.count {
            testFontText.append("")
        }
    }
    
    func isSelected(index: Int) -> Bool {
        return selectedIndex == index
    }
    
    func selectedUIFont(font: String, size: CGFloat) -> UIFont {
        if font == "SFMONO" {
            return UIFont.monospacedSystemFont(ofSize: size, weight: .regular)
        }  else if font == "SFDisplay" {
            return UIFont.systemFont(ofSize: size)
        } else {
            return UIFont(name: font, size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    func selectedFont(font: String, size: CGFloat) -> Font {
        if font == "SFMONO" {
            return .system(size: size, design: .monospaced)
        } else if font == "SFDisplay" {
            return .system(size: size)
        } else {
            return .custom(font, size: size)
        }
    }
    
    func fontsizeCheck(font: String, screenWidth: Int) -> CGFloat {
        return 15.0
    }
}
