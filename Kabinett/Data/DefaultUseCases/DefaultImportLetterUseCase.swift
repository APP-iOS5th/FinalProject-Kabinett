//
//  DefaultImportLetterUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 9/5/24.
//

import Foundation
import Combine
import os

final class DefaultImportLetterUseCase {
    private let logger: Logger
    private let authManager: AuthManager
    private let writerManager: FirestoreWriterManager
    private let letterManager: FirestoreLetterWriteManager
    private let letterStorageManager: FirestorageLetterManager
    
    init(
        authManager: AuthManager,
        writerManager: FirestoreWriterManager,
        letterManager: FirestoreLetterWriteManager,
        letterStorageManager: FirestorageLetterManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultImportLetterUseCase"
        )
        self.authManager = authManager
        self.writerManager = writerManager
        self.letterManager = letterManager
        self.letterStorageManager = letterStorageManager
    }
}

extension DefaultImportLetterUseCase: ImportLetterUseCase {
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
    
    // TODO: - Refactor this codes
    func findWriter(by query: String) async -> [Writer] {
        do {
            async let resultByName = letterManager.findDocuments(
                by: Query(key: "name", value: query),
                as: Writer.self
            )
            async let resultByNumber = letterManager.findDocuments(
                by: Query(key: "kabinettNumber", value: query),
                as: Writer.self
            )
            
            return try await resultByName + resultByNumber
        } catch {
            logger.error("Find writer error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getCurrentWriter() -> AnyPublisher<Writer, Never> {
        authManager
            .getCurrentUser()
            .compactMap { $0 }
            .asyncMap { [weak self] user in
                await self?.writerManager.getWriterDocument(with: user.uid)
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    // 편지봉투 로딩
    func loadEnvelopes() async -> Result<[String], any Error> {
        await letterStorageManager.loadStorage(path: "Envelopes")
    }
    
    // 우표 로딩
    func loadStamps() async -> Result<[String], any Error> {
        await letterStorageManager.loadStorage(path: "Stamps")
    }
}
