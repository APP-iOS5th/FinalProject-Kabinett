//
//  Extension.swift
//  Kabinett
//
//  Created by Song Kim on 8/20/24.
//

import Foundation
import SwiftUI
import Combine

extension Font {
    static let SFDisplay: Font = .system(size: 14)
    static let SFDisplay_SemiBold: Font = .system(size: 14, weight: .semibold)
    static let SFMONO: Font = .system(size: 14, design: .monospaced)
    static let SFMONO_Bold: Font = .system(size: 14, weight: .semibold)
    static let SourceHanSerifK_Regular: Font = .custom("SourceHanSerifK-Regular", size: 14)
    static let SourceHanSerifK_Bold: Font = .custom("SourceHanSerifK-Bold", size: 14)
    static let MaruBuriot_Bold: Font = .custom("MaruBuriot-Bold", size: 14)
    static let MaruBuriot_Regular: Font = .custom("MaruBuriot-Regular", size: 14)
    static let goormSansOTF4: Font = .custom("goormSansOTF4", size: 14)
    static let Baskervville_Regular: Font = .custom("Baskervville-Regular", size: 14)
    static let Pecita: Font = .custom("Pecita", size: 13)
    
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
