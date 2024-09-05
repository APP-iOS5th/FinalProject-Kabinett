//
//  DefaultPhotoLetterUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 9/5/24.
//

import Foundation
import FirebaseFirestore
import os

final class DefaultPhotoLetterUseCase {
    private let logger: Logger
    private let db = Firestore.firestore()
    private let authManager: AuthManager
    private let writerManager: FirestoreWriterManager
    private let letterManager: FirestoreLetterManager
    
    init(
        authManager: AuthManager,
        writerManager: FirestoreWriterManager,
        letterManager: FirestoreLetterManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultPhotoLetterUseCase"
        )
        self.authManager = authManager
        self.writerManager = writerManager
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
            return .failure(error)
        }
    }
}
