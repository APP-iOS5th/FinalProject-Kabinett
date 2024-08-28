//
//  KabinettNumberFormatter.swift
//  Kabinett
//
//  Created by Yule on 8/28/24.
//

import Foundation

func formatKabinettNumber(_ number: Int) -> String {
    return String(format: "%03d-%03d", number / 1000, number % 1000)
}
