//
//  LetterWriteUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/12/24.
//

import Foundation

protocol LetterWriteUseCase {
    func saveLetter(font: String, postScript: String?, envelope: String, stamp: String, fromUserId: String, toUserId: String, content: String?, photoContents: [String], date: Date, stationery: String, isRead: Bool) async -> Result<Void, Error>
}
