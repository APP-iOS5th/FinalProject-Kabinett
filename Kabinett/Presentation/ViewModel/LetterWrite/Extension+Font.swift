//
//  Extension.swift
//  Kabinett
//
//  Created by Song Kim on 8/20/24.
//

import Foundation
import SwiftUI
import UIKit

extension Font {
    static let SFDisplay: Font = .system(size: 13)
    static let SFDisplay_SemiBold: Font = .system(size: 13, weight: .semibold)
    static let SFMONO: Font = .system(size: 13, design: .monospaced)
    static let SFMONO_Bold: Font = .system(size: 13, weight: .semibold)
    static let SourceHanSerifK_Regular: Font = .custom("SourceHanSerifK-Regular", size: 13)
    static let SourceHanSerifK_Bold: Font = .custom("SourceHanSerifK-Bold", size: 13)
    static let MaruBuriot_Bold: Font = .custom("MaruBuriot-Bold", size: 13)
    static let MaruBuriot_Regular: Font = .custom("MaruBuriot-Regular", size: 13)
    static let goormSansOTF4: Font = .custom("goormSansOTF4", size: 13)
    static let Baskervville_Regular: Font = .custom("Baskervville-Regular", size: 13)
    static let Pecita: Font = .custom("Pecita", size: 14)
}

extension UIFont {
    static let SFDisplay: UIFont = .systemFont(ofSize: 13)
    static let SFDisplay_SemiBold: UIFont = .systemFont(ofSize: 13, weight: .semibold)
    static let SFMONO: UIFont = .monospacedSystemFont(ofSize: 13, weight: .regular)
    static let SFMONO_Bold: UIFont = .monospacedSystemFont(ofSize: 13, weight: .bold)
    static let SourceHanSerifK_Regular: UIFont = .init(name: "SourceHanSerifK-Regular", size: 11.9)!
    static let SourceHanSerifK_Bold: UIFont = .init(name: "SourceHanSerifK-Bold", size: 11.9)!
    static let MaruBuriot_Bold: UIFont = .init(name: "MaruBuriot-Bold", size: 12)!
    static let MaruBuriot_Regular: UIFont = .init(name: "MaruBuriot-Regular", size: 12)!
    static let goormSansOTF4: UIFont = .init(name: "goormSansOTF4", size: 13)!
    static let Baskervville_Regular: UIFont = .init(name: "Baskervville-Regular", size: 13)!
    static let Pecita: UIFont = .init(name: "Pecita", size: 14.5)!
}
