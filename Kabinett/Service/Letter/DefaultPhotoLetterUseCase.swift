//
//  DefaultPhotoLetterUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 9/5/24.
//

import Foundation
import os

final class DefaultPhotoLetterUseCase {
    private let logger: Logger
    private let letterManager: FirestoreLetterManager
    
    init(
        letterManager: FirestoreLetterManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultPhotoLetterUseCase"
        )
        self.letterManager = letterManager
    }
}

extension DefaultPhotoLetterUseCase: ComponentsUseCase {
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
    ) async -> Result<Bool, any Error> {
        do {
            let photoContentStringUrl = try await letterManager.convertPhotoToUrl(photoContents: photoContents)
            
            let letter = Letter(
                id: nil,
                fontString: nil,
                postScript: postScript ?? "",
                envelopeImageUrlString: envelope,
                stampImageUrlString: stamp,
                fromUserId: fromUserId ?? "",
                fromUserName: fromUserName,
                fromUserKabinettNumber: fromUserKabinettNumber ?? 0,
                toUserId: toUserId ?? "",
                toUserName: toUserName,
                toUserKabinettNumber: toUserKabinettNumber ?? 0,
                content: [],
                photoContents: photoContentStringUrl,
                date: date,
                stationeryImageUrlString: nil,
                isRead: isRead)
            
            return await letterManager.saveLetterToFireStore(letter: letter, fromUserId: fromUserId, toUserId: toUserId)
        } catch {
            logger.error("Failed to save Photo Letter: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
