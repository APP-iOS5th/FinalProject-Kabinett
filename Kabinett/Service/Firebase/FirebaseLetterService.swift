//
//  FirebaseLetterService.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/13/24.
//

import Foundation
import FirebaseFirestore

enum LetterError: Error {
    case invalidFont
    case invalidEnvelope
    case invalidStamp
    case invalidFromUserId
    case invalidToUserId
    case invalidPhotoContents
    case invalidStationery
}

enum LetterSaveError: Error {
    case invalidFromUserDoc
    case invalidToUserDoc
    case failedToSaveToMe
    case failedToSaveSent
    case failedToSaveReceived
    case failedToSaveBoth
}

final class FirebaseLetterService: LetterWriteUseCase, ComponentsUseCase {
    
    let db = Firestore.firestore()
    
    // LetterWriteUseCase
    func saveLetter(font: String, postScript: String?, envelope: String, stamp: String,
                    fromUserId: String, toUserId: String, content: String?, photoContents: [String], date: Date,
                    stationery: String, isRead: Bool) async -> Result<Void, any Error> {
        
        // MARK: - Parameter 유효성 검사
        guard !font.isEmpty else { return .failure(LetterError.invalidFont) }
        guard !envelope.isEmpty else { return .failure(LetterError.invalidEnvelope) }
        guard !stamp.isEmpty else { return .failure(LetterError.invalidStamp) }
        guard !fromUserId.isEmpty else { return .failure(LetterError.invalidFromUserId) }
        guard !toUserId.isEmpty else { return .failure(LetterError.invalidToUserId) }
        guard !stationery.isEmpty else { return .failure(LetterError.invalidStationery) }
        
        do {
            try await validateUsers(fromUserId: fromUserId, toUserId: toUserId)
            
            let letter = Letter(
                id: nil,
                fontString: font,
                postScript: postScript ?? "",
                envelopeImageUrlString: envelope,
                stampImageUrlString: stamp,
                fromUserId: fromUserId,
                toUserId: toUserId,
                content: content ?? "",
                photoContents: photoContents,
                date: date,
                stationeryImageUrlString: stationery,
                isRead: isRead)
            
            return await saveLetterToFireStore(letter: letter, fromUserId: fromUserId, toUserId: toUserId)
            
        } catch {
            return .failure(error)
        }
    }
    
    // ComponentsUsesCase
    func saveLetter(postScript: String?, envelope: String, stamp: String, fromUserId: String, toUserId: String, photoContents: [String], date: Date, isRead: Bool) async -> Result<Void, any Error> {
        
        // MARK: - Parameter 유효성 검사
        guard !envelope.isEmpty else { return .failure(LetterError.invalidEnvelope) }
        guard !stamp.isEmpty else { return .failure(LetterError.invalidStamp) }
        guard !fromUserId.isEmpty else { return .failure(LetterError.invalidFromUserId) }
        guard !toUserId.isEmpty else { return .failure(LetterError.invalidToUserId) }
        guard !photoContents.isEmpty else { return .failure(LetterError.invalidPhotoContents) }
        
        do {
            try await validateUsers(fromUserId: fromUserId, toUserId: toUserId)
            
            let letter = Letter(
                id: nil,
                fontString: nil,
                postScript: postScript ?? "",
                envelopeImageUrlString: envelope,
                stampImageUrlString: stamp,
                fromUserId: fromUserId,
                toUserId: toUserId,
                content: nil,
                photoContents: photoContents,
                date: date,
                stationeryImageUrlString: nil,
                isRead: isRead)
            
            return await saveLetterToFireStore(letter: letter, fromUserId: fromUserId, toUserId: toUserId)
            
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - 유저 유효성 검사
    private func validateUsers(fromUserId: String, toUserId: String) async throws {
        let fromUserDoc = db.collection("Writer").document(fromUserId)
        let toUserDoc = db.collection("Writer").document(toUserId)
        
        let snapshotFrom = try await fromUserDoc.getDocument()
        guard snapshotFrom.exists else { throw LetterSaveError.invalidFromUserDoc }
        
        if fromUserId != toUserId {
            let snapshotTo = try await toUserDoc.getDocument()
            guard snapshotTo.exists else { throw LetterSaveError.invalidToUserDoc }
        }
    }
    
    // MARK: - Firestore Letter 저장
    private func saveLetterToFireStore(letter: Letter, fromUserId: String, toUserId: String) async -> Result<Void, any Error> {
        
        do {
            let fromUserDoc = db.collection("Writer").document(fromUserId)
            let toUserDoc = db.collection("Writer").document(toUserId)
            
            let letterData = try Firestore.Encoder().encode(letter)
            
            if fromUserId == toUserId {
                do {
                    try await fromUserDoc.collection("ToMe").addDocument(data: letterData)
                    return .success(())
                } catch {
                    return .failure(LetterSaveError.failedToSaveToMe)
                }
            } else {
                var sentSaveError: Error?
                var receivedSaveError: Error?
                
                do {
                    try await fromUserDoc.collection("Sent").addDocument(data: letterData)
                } catch {
                    sentSaveError = error
                }
                
                do {
                    try await toUserDoc.collection("Received").addDocument(data: letterData)
                } catch {
                    receivedSaveError = error
                }
                
                if let _ = sentSaveError, let _ = receivedSaveError {
                    return .failure(LetterSaveError.failedToSaveBoth)
                } else if let _ = sentSaveError {
                    return .failure(LetterSaveError.failedToSaveSent)
                } else if let _ = receivedSaveError {
                    return .failure(LetterSaveError.failedToSaveReceived)
                }
                
                return .success(())
            }
        } catch {
            return .failure(error)
        }
        
    }
}
