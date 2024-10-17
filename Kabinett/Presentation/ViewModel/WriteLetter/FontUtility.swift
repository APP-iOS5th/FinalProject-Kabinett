//
//  FontUtility.swift
//  Kabinett
//
//  Created by Song Kim on 10/17/24.
//

import Foundation
import SwiftUI
import UIKit

class FontUtility {
    static let screenSize = UIScreen.main.bounds.width
    
    static func selectedUIFont(font: String, size: CGFloat) -> UIFont {
        if font == "SFMONO" {
            return UIFont.monospacedSystemFont(ofSize: size, weight: .regular)
        }  else if font == "SFDisplay" {
            return UIFont.systemFont(ofSize: size)
        } else {
            return UIFont(name: font, size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    static func selectedFont(font: String, size: CGFloat) -> Font {
        if font == "SFMONO" {
            return .system(size: size, design: .monospaced)
        } else if font == "SFDisplay" {
            return .system(size: size)
        } else {
            return .custom(font, size: size)
        }
    }
    
    static func fontSize(font: String) -> CGFloat {
        if font == "SourceHanSerifK-Regular" {
            return screenSize * 0.0333
        } else if font == "NanumMyeongjoOTF" {
            return screenSize * 0.0392
        } else if font == "Baskervville-Regular" {
            return screenSize * 0.0369
        } else if font == "Pecita" {
            return screenSize * 0.037
        }
        return (screenSize * 0.0382)
    }
    
    static func lineSpacing(font: String) -> CGFloat {
        if font == "Pecita" {
            return screenSize * 0.0069
        } else if font == "SFDisplay" {
            return screenSize * 0.0013
        } else if font == "goormSansOTF4" {
            return screenSize * 0.0013
        }  else if font == "Baskervville-Regular" {
            return screenSize * 0.002
        }
        return 0.0
    }
    
    static func kerning(font: String) -> CGFloat {
        if font == "SFMONO" {
            return -(screenSize * 0.0025)
        } else if font == "SFDisplay" {
            return (screenSize * 0.0005)
        } else if font == "goormSansOTF4" {
            return (screenSize * 0.001)
        }
        return 0.0
    }
}
