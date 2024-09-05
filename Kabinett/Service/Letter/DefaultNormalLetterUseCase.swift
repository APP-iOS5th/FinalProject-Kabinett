//
//  DefaultNormalLetterUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 9/5/24.
//

import Foundation
import FirebaseFirestore
import os

final class DefaultNormalLetterUseCase {
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
            category: "DefaultNormalLetterUseCase"
        )
        self.authManager = authManager
        self.writerManager = writerManager
        self.letterManager = letterManager
    }
}

extension DefaultNormalLetterUseCase: LetterWriteUseCase {
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
    ) async -> Result<Bool, any Error> {
        
        do {
//            try await validateFromUser(fromUserId: fromUserId)
            let photoContentStringUrl: [String]
            if !photoContents.isEmpty {
                photoContentStringUrl = try await letterManager.convertPhotoToUrl(photoContents: photoContents)
            } else {
                photoContentStringUrl = []
            }
            
            let letter = Letter(
                id: nil,
                fontString: font,
                postScript: postScript ?? "",
                envelopeImageUrlString: envelope,
                stampImageUrlString: stamp,
                fromUserId: fromUserId ?? "",
                fromUserName: fromUserName,
                fromUserKabinettNumber: fromUserKabinettNumber ?? 0,
                toUserId: toUserId ?? "",
                toUserName: toUserName,
                toUserKabinettNumber: toUserKabinettNumber ?? 0,
                content: content,
                photoContents: photoContentStringUrl,
                date: date,
                stationeryImageUrlString: stationery,
                isRead: isRead)
            
            return await letterManager.saveLetterToFireStore(letter: letter, fromUserId: fromUserId, toUserId: toUserId)
            
        } catch {
            return .failure(error)
        }
    }
    
    // TODO: - Refactor this codes
    func findWriter(by query: String) async -> [Writer] {
        do {
            async let resultByName = findDocuments(
                by: Query(key: "name", value: query),
                as: Writer.self
            )
            async let resultByNumber = findDocuments(
                by: Query(key: "kabinettNumber", value: query),
                as: Writer.self
            )
            
            return try await resultByName + resultByNumber
        } catch {
            logger.error("Find writer error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getCurrentWriter() async -> Writer {
        if let user = authManager.getCurrentUser() {
            return await writerManager.getWriterDocument(with: user.uid)
        } else {
            return .anonymousWriter
        }
    }
    
    private struct Query {
        let key: String
        let value: String
    }
    
    private func findDocuments<T: Codable>(
        by query: Query,
        as type: T.Type
    ) async throws -> [T] {
        return try await db.collection("Writers")
            .whereField(query.key, isEqualTo: query.value)
            .getDocuments()
            .documents
            .map { try $0.data(as: type) }
    }
    
}
