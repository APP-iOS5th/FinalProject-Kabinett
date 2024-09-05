//
//  FirebaseFirestoreManager.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/13/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Combine
import os

enum LetterError: Error {
    case invalidLetterId
    case invalidFont
    case invalidEnvelope
    case invalidStamp
    case invalidFromUserName
    case invalidToUserName
    case invalidPhotoContents
    case invalidStationery
    case invalidUser
}

enum LetterSaveError: Error {
    case invalidFromUserDoc
    case invalidToUserDoc
    case failedToSaveToMe
    case failedToSaveSent
    case failedToSaveReceived
    case failedToSaveBoth
    case failedConvertPhotoURL
    case bothUsersNotFound
}

final class FirestoreLetterManager {
    private let logger: Logger
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let authManager: AuthManager
    private let writerManager: FirestoreWriterManager
    
    init(
        authManager: AuthManager,
        writerManager: FirestoreWriterManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "FirebaseFirestoreManager"
        )
        self.authManager = authManager
        self.writerManager = writerManager
    }
    
    // MARK: - 유효성 검사
    func validateFromUser(fromUserId: String?) async throws {
        let fromUserDoc = fromUserId.flatMap { !$0.isEmpty ? db.collection("Writers").document($0) : nil }
        
        let fromUserSnapshot = fromUserDoc != nil ? try await fromUserDoc!.getDocument() : nil
        guard let fromUserSnapshot = fromUserSnapshot, fromUserSnapshot.exists else { throw LetterSaveError.invalidFromUserDoc }
    }
    
   func validateLetter(
        userId: String,
        letterId: String,
        letterType: String
    ) async throws {
        let letterDoc = db.collection("Writers")
            .document(userId)
            .collection(letterType)
            .document(letterId)
        
        let letterSnapshot = try await letterDoc.getDocument()
        guard letterSnapshot.exists else { throw LetterError.invalidLetterId }
    }
    
    // MARK: - 유저 DocumentID 가져오기
    private func getCurrentUserId() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = authManager.getCurrentUser()
                .first()
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { user in
                    if let uid = user?.uid {
                        continuation.resume(returning: uid)
                    } else {
                        continuation.resume(throwing: LetterError.invalidUser)
                    }
                    cancellable?.cancel()
                }
        }
    }
    
    // MARK: - Firestore Letter 저장
    func saveLetterToFireStore(
        letter: Letter,
        fromUserId: String?,
        toUserId: String?
    ) async -> Result<Bool, any Error> {
        do {
            let fromUserDoc = fromUserId.flatMap { !$0.isEmpty ? db.collection("Writers").document($0) : nil }
            let toUserDoc = toUserId.flatMap { !$0.isEmpty ? db.collection("Writers").document($0) : nil }
            
            let fromUserSnapshot = fromUserDoc != nil ? try await fromUserDoc!.getDocument() : nil
            let toUserSnapshot = toUserDoc != nil ? try await toUserDoc!.getDocument() : nil
            
            // User 검색용 필드 추가
            let searchUser: [String] = [
                letter.fromUserName,
                String(letter.fromUserKabinettNumber ?? 0),
                letter.toUserName,
                String(letter.toUserKabinettNumber ?? 0)
            ].compactMap { $0.lowercased() }
                .flatMap { $0.split(separator: " ").map(String.init) }
            
            // fromUser가 존재하고, fromUserId와 toUserId가 같은 경우 -> ToMe
            if let fromUserSnapshot = fromUserSnapshot, fromUserSnapshot.exists && fromUserId == toUserId {
                do {
                    var letterData = try Firestore.Encoder().encode(letter)
                    letterData["searchUser"] = searchUser
                    
                    try await fromUserDoc!.collection("ToMe").addDocument(data: letterData)
                    return .success(true)
                } catch {
                    return .failure(LetterSaveError.failedToSaveToMe)
                }
                // fromUser, toUser가 존재하는데 두 User가 다른 경우 -> Sent, Received
            } else if let fromUserSnapshot = fromUserSnapshot, let toUserSnapshot = toUserSnapshot,
                      fromUserSnapshot.exists && toUserSnapshot.exists && fromUserId != toUserId {
                var sentSaveError: Error?
                var receivedSaveError: Error?
                
                do {
                    var sentLetter = letter
                    sentLetter.isRead = true
                    
                    var letterSentData = try Firestore.Encoder().encode(sentLetter)
                    letterSentData["searchUser"] = searchUser
                    
                    try await fromUserDoc!.collection("Sent").addDocument(data: letterSentData)
                } catch {
                    sentSaveError = error
                }
                
                do {
                    var letterData = try Firestore.Encoder().encode(letter)
                    letterData["searchUser"] = searchUser
                    
                    try await toUserDoc!.collection("Received").addDocument(data: letterData)
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
                return .success(true)
                // fromUser가 존재하고, toUser가 존재하지 않을 때 -> Sent
            } else if let fromUserSnapshot = fromUserSnapshot, fromUserSnapshot.exists,
                      toUserSnapshot == nil || !toUserSnapshot!.exists {
                do {
                    var sentLetter = letter
                    sentLetter.isRead = true
                    
                    var letterSentData = try Firestore.Encoder().encode(sentLetter)
                    letterSentData["searchUser"] = searchUser
                    
                    try await fromUserDoc!.collection("Sent").addDocument(data: letterSentData)
                    return .success(true)
                } catch {
                    return .failure(LetterSaveError.failedToSaveSent)
                }
                // fromUser가 존재하지 않고, toUser가 존재할 때 -> Received
            } else if fromUserSnapshot == nil || !fromUserSnapshot!.exists,
                      let toUserSnapshot = toUserSnapshot, toUserSnapshot.exists {
                do {
                    var letterData = try Firestore.Encoder().encode(letter)
                    letterData["searchUser"] = searchUser
                    
                    try await toUserDoc!.collection("Received").addDocument(data: letterData)
                    return .success(true)
                } catch {
                    return .failure(LetterSaveError.failedToSaveReceived)
                }
                // 두 User가 모두 없을 때 -> failure
            } else {
                return .failure(LetterSaveError.bothUsersNotFound)
            }
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Firestore 전체 Letter 불러오기
    private func getAllLetters(userId: String) async -> Result<[Letter], any Error> {
        do {
            let collectionNames = ["Sent", "Received", "ToMe"]
            var allLetters: [Letter] = []
            
            for name in collectionNames {
                let snapshot = try await db.collection("Writers")
                    .document(userId)
                    .collection(name)
                    .getDocuments()
                
                let letters = try snapshot.documents.compactMap { document in
                    try document.data(as: Letter.self)
                }
                allLetters.append(contentsOf: letters)
            }
            allLetters.sort { $0.date > $1.date }
            
            return .success(allLetters)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - PhotoContents URL 변환
    func convertPhotoToUrl(photoContents: [Data]) async throws -> [String] {
        let storageRef = storage.reference()
        
        return try await withThrowingTaskGroup(of: String.self) { taskGroup in
            var photoContentUrlStrings: [String] = []
            
            for photoContent in photoContents {
                taskGroup.addTask {
                    let photoRef = storageRef.child("Users/photoContents/\(UUID().uuidString).jpg")
                    
                    _ = try await photoRef.putDataAsync(photoContent, metadata: nil)
                    
                    let downloadURL = try await photoRef.downloadURL()
                    return downloadURL.absoluteString
                }
            }
            
            for try await urlString in taskGroup {
                photoContentUrlStrings.append(urlString)
            }
            
            return photoContentUrlStrings
        }
    }
}
