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
    var boldFont: String
    var regularFont: String
}

class FontSelectionViewModel: ObservableObject {
    @Published var testFontText: [String] = []
    @Published var selectedIndex: Int = 0
    @Published var showModal: Bool = false
    @Published var dummyFonts: [Fonts] = [
        Fonts(fontName: "SF Display", boldFont: "SFDisplay_SemiBold", regularFont: "SFDisplay"),
        Fonts(fontName: "SF MONO", boldFont: "SFMONO_Bold", regularFont: "SFMONO"),
        Fonts(fontName: "Source Han Serif 본명조", boldFont: "SourceHanSerifK-Bold", regularFont: "SourceHanSerifK-Regular"),
        Fonts(fontName: "네이버 나눔명조", boldFont: "MaruBuriot-Bold", regularFont: "MaruBuriot-Regular"),
        Fonts(fontName: "구름 산스 코드", boldFont: "goormSansOTF4", regularFont: "goormSansOTF4"),
        Fonts(fontName: "Baskervville", boldFont: "Baskervville-Regular", regularFont: "Baskervville-Regular"),
        Fonts(fontName: "Pecita", boldFont: "Pecita", regularFont: "Pecita"),
    ]
    
    func font(file: String) -> Font {
        switch file {
        case "SFDisplay":
            return .SFDisplay
        case "SFDisplay_SemiBold":
            return .SFDisplay_SemiBold
        case "SFMONO":
            return .SFMONO
        case "SFMONO_Bold":
            return .SFMONO_Bold
        case "SourceHanSerifK-Regular":
            return .SourceHanSerifK_Regular
        case "SourceHanSerifK-Bold":
            return .SourceHanSerifK_Bold
        case "MaruBuriot-Regular":
            return .MaruBuriot_Regular
        case "MaruBuriot-Bold":
            return .MaruBuriot_Bold
        case "goormSansOTF4":
            return .goormSansOTF4
        case "Baskervville-Regular":
            return .Baskervville_Regular
        case "Pecita":
            return .Pecita
        default:
            return .system(size: 14)
        }
    }
    
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
    
    func selectedUIFont(font: String) -> UIFont {
        if font == "SFMONO" {
            return UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        } else {
            return UIFont(name: font, size: 15) ?? UIFont.systemFont(ofSize: 15)
        }
    }
    
    func selectedFont(font: String, size: CGFloat) -> Font {
        if font == "SFMONO" {
            return .system(size: size, design: .monospaced)
        } else {
            return .custom("font", size: size)
        }
    }
}
