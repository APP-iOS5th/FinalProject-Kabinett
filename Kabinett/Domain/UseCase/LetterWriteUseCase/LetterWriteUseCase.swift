//
//  LetterWriteUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/12/24.
//

import Foundation

protocol LetterWriteUseCase {
    func saveLetter(font: String, 
                    postScript: String?,
                    envelope: String,
                    stamp: String,
                    fromUserId: String?, 
                    fromUserName: String,
                    fromUserKabinettNumber: Int?,
                    toUserId: String?, 
                    toUserName: String,
                    toUserKabinettNumber: Int?,
                    content: [String],
                    photoContents: [Data],
                    date: Date,
                    stationery: String,
                    isRead: Bool
    ) async -> Result<Bool, any Error>
}
