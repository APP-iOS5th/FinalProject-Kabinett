//
//  ImportLetterUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/12/24.
//

import Foundation
import Combine

protocol ImportLetterUseCase {
    func saveLetter(postScript: String?, 
                    envelope: String,
                    stamp: String,
                    fromUserId: String?, 
                    fromUserName: String,
                    fromUserKabinettNumber: Int?,
                    toUserId: String?, 
                    toUserName: String,
                    toUserKabinettNumber: Int?,
                    photoContents: [Data],
                    date: Date,
                    isRead: Bool
    ) async -> Result<Bool, any Error>
    func findWriter(by query: String) async -> [Writer]
    func getCurrentWriter() -> AnyPublisher<Writer, Never>
    
    func loadEnvelopes() async -> Result<[String], any Error>
    func loadStamps() async -> Result<[String], any Error>
}
