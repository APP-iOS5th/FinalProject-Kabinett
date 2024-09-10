//
//  LetterHelper.swift
//  Kabinett
//
//  Created by uunwon on 9/10/24.
//

import Foundation

class LetterHelper {
    static func calculateTotalPageCount(for letter: Letter) -> Int {
        if letter.content.isEmpty && letter.photoContents.isEmpty {
            return 1
        }
        if letter.content.isEmpty && !letter.photoContents.isEmpty {
            return letter.photoContents.count
        }
        return letter.content.count + letter.photoContents.count
    }
}
