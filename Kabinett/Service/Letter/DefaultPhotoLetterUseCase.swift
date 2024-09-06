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
    private let authManager: AuthManager
    private let writerManager: FirestoreWriterManager
    private let letterManager: FirestoreLetterManager
    private let letterStorageManager: FirestoreLetterManager
    
    init(
        authManager: AuthManager,
        writerManager: FirestoreWriterManager,
        letterManager: FirestoreLetterManager,
        letterStorageManager: FirestoreLetterManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultPhotoLetterUseCase"
        )
        self.authManager = authManager
        self.writerManager = writerManager
        self.letterManager = letterManager
        self.letterStorageManager = letterStorageManager
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
            let photoContentStringUrl = try await letterStorageManager.convertPhotoToUrl(photoContents: photoContents)
            
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
