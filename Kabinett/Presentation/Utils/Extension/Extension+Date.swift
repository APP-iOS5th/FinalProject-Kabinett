//
//  Extension+Date.swift
//  Kabinett
//
//  Created by Song Kim on 8/27/24.
//

import Foundation

extension Date {
    func formattedString(format: String = "yyyy년 M월 d일") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
