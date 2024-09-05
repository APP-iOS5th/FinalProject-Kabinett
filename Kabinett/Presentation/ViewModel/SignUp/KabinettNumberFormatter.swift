//
//  KabinettNumberFormatter.swift
//  Kabinett
//
//  Created by Yule on 8/28/24.
//

import Foundation

extension Int {
    func formatKabinettNumber() -> String {
        return String(format: "%03d-%03d", self / 1000, self % 1000)
    }
}
