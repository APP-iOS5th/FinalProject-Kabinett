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
    case invalidPhtoContents
    case invalidStationery
    case invalidFromUser
    case invalidToUser
}

final class FirebaseLetterService: LetterWriteUseCase, ComponentsUseCase {
    
    let db = Firestore.firestore()
    
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
        
        // MARK: - Letter 객체 생성
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
        
        // MARK: - Firestore 저장
        let fromUserDoc = db.collection("Writer").document(fromUserId)
        let toUserDoc = db.collection("Writer").document(toUserId)
        
        if fromUserId == toUserId {
            do {
                let snapshot = try await fromUserDoc.getDocument()
                guard snapshot.exists else {
                    return .failure(LetterError.invalidFromUser)
                }
                
                let letterData = try Firestore.Encoder().encode(letter)
                
                try await fromUserDoc.collection("ToMe").addDocument(data: letterData)
                return .success(())
                
            } catch {
                return .failure(error)
            }
        } else {
            do {
                let snapshotFrom = try await fromUserDoc.getDocument()
                let snapshotTo = try await toUserDoc.getDocument()
                
                guard snapshotFrom.exists else {
                    return .failure(LetterError.invalidFromUser)
                }
                guard snapshotTo.exists else {
                    return .failure(LetterError.invalidToUser)
                }
                
                let letterData = try Firestore.Encoder().encode(letter)
                
                try await fromUserDoc.collection("Sent").addDocument(data: letterData)
                try await toUserDoc.collection("Received").addDocument(data: letterData)
                
                return .success(())
                
            } catch {
                return .failure(error)
            }
        }
    }
    
    func saveLetter(postScript: String?, envelope: String, stamp: String, fromUserId: String, toUserId: String, photoContents: [String], date: Date, isRead: Bool) async -> Result<Void, any Error> {
        
        // MARK: - Parameter 유효성 검사
        guard !envelope.isEmpty else { return .failure(LetterError.invalidEnvelope) }
        guard !stamp.isEmpty else { return .failure(LetterError.invalidStamp) }
        guard !fromUserId.isEmpty else { return .failure(LetterError.invalidFromUserId) }
        guard !photoContents.isEmpty else { return .failure(LetterError.invalidPhtoContents) }
        guard !toUserId.isEmpty else { return .failure(LetterError.invalidToUserId) }
        
        // MARK: - Letter 객체 생성
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
        
        // MARK: - Firestore 저장
        let fromUserDoc = db.collection("Writer").document(fromUserId)
        let toUserDoc = db.collection("Writer").document(toUserId)
        
        if fromUserId == toUserId {
            do {
                let snapshot = try await fromUserDoc.getDocument()
                guard snapshot.exists else {
                    return .failure(LetterError.invalidFromUser)
                }
                
                let letterData = try Firestore.Encoder().encode(letter)
                
                try await fromUserDoc.collection("ToMe").addDocument(data: letterData)
                return .success(())
                
            } catch {
                return .failure(error)
            }
        } else {
            do {
                let snapshotFrom = try await fromUserDoc.getDocument()
                let snapshotTo = try await toUserDoc.getDocument()
                
                guard snapshotFrom.exists else {
                    return .failure(LetterError.invalidFromUser)
                }
                guard snapshotTo.exists else {
                    return .failure(LetterError.invalidToUser)
                }
                
                let letterData = try Firestore.Encoder().encode(letter)
                
                try await fromUserDoc.collection("Sent").addDocument(data: letterData)
                try await toUserDoc.collection("Received").addDocument(data: letterData)
                
                return .success(())
                
            } catch {
                return .failure(error)
            }
        }
    }
}
