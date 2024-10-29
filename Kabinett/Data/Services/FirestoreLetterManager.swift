//
//  FirebaseFirestoreManager.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/13/24.
//

import Foundation
import FirebaseFirestore
import Combine
import os

enum LetterError: Error {
    case invalidLetterId
    case invalidUser
    case identityUser
}

enum LetterSaveError: Error {
    case failedToSaveToMe
    case failedToSaveSent
    case failedToSaveReceived
    case failedToSaveBoth
    case failedConvertPhotoURL
    case bothUsersNotFound
}

struct Query {
    let key: String
    let value: String
}

final class FirestoreLetterManager {
    private let logger: Logger
    private let db = Firestore.firestore()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "FirebaseFirestoreManager"
        )
    }
    
    actor SafeListeners {
        var listeners: [ListenerRegistration] = []
        
        func addListener(_ listener: ListenerRegistration) {
            listeners.append(listener)
        }
        
        func removeAllListeners() {
            listeners.forEach { $0.remove() }
            listeners.removeAll()
        }
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
                    logger.error("Save ToMe Error: \(error.localizedDescription)")
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
                    logger.error("Save Sent, Received Error: \(LetterSaveError.failedToSaveBoth)")
                    return .failure(LetterSaveError.failedToSaveBoth)
                } else if let _ = sentSaveError {
                    logger.error("Save Sent Error: \(LetterSaveError.failedToSaveSent)")
                    return .failure(LetterSaveError.failedToSaveSent)
                } else if let _ = receivedSaveError {
                    logger.error("Save Received Error: \(LetterSaveError.failedToSaveReceived)")
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
                    logger.error("Save Sent Error: \(error.localizedDescription)")
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
                    logger.error("Save Received Error: \(error.localizedDescription)")
                    return .failure(LetterSaveError.failedToSaveReceived)
                }
                // 두 User가 모두 없을 때 -> failure
            } else {
                logger.error("Both User Found Error: \(LetterSaveError.bothUsersNotFound)")
                return .failure(LetterSaveError.bothUsersNotFound)
            }
        } catch {
            logger.error("Save Firestore Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    func getLetters(
        userId: String,
        letterType: [String]
    ) -> AnyPublisher<[Letter], Never> {
        let publishers = letterType.map { type in
            createLetterPublisher(userId: userId, type: type)
        }
        
        return Publishers.MergeMany(publishers)
            .scan([Letter]()) { accumulated, changes in
                self.mergeLetterChanges(existingLetters: accumulated, changes: changes)
            }
            .map { $0.sorted { $0.date > $1.date } }
            .eraseToAnyPublisher()
    }
    
    private func createLetterPublisher(
        userId: String,
        type: String
    ) -> AnyPublisher<[(Letter?, DocumentChangeType)], Never> {
        let subject = PassthroughSubject<[(Letter?, DocumentChangeType)], Never>()
        
        let listener = db.collection("Writers")
            .document(userId)
            .collection(type)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.logger.error("Error fetching snapshots: \(error.localizedDescription)")
                    subject.send([])
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    self.logger.error("Snapshot is nil")
                    subject.send([])
                    return
                }
                
                let changes = snapshot.documentChanges.map { change -> (Letter?, DocumentChangeType) in
                    let letter = try? change.document.data(as: Letter.self)
                    return (letter, change.type)
                }
                subject.send(changes)
            }
        
        return subject
            .handleEvents(receiveCancel: {
                listener.remove()
            })
            .eraseToAnyPublisher()
    }
    
    private func mergeLetterChanges(
        existingLetters: [Letter],
        changes: [(Letter?, DocumentChangeType)]
    ) -> [Letter] {
        var updatedLetters = existingLetters
        
        for (letter, changeType) in changes {
            switch changeType {
            case .removed:
                if let letter = letter {
                    updatedLetters.removeAll { $0.id == letter.id }
                }
            case .added, .modified:
                if let letter = letter {
                    if let index = updatedLetters.firstIndex(where: { $0.id == letter.id }) {
                        updatedLetters[index] = letter
                    } else {
                        updatedLetters.append(letter)
                    }
                }
            }
        }
        return updatedLetters
    }
    
    func searchByKeyword(
        userId: String,
        keyword: String,
        letterType: [String]
    ) async -> Result<[Letter]?, any Error> {
        do {
            var letterResult: [Letter] = []
            
            for type in letterType {
                let snapshot = try await db.collection("Writers")
                    .document(userId)
                    .collection(type)
                    .whereField("searchUser", arrayContains: keyword)
                    .getDocuments()
                
                let letters = try snapshot.documents.compactMap { document in
                    try document.data(as: Letter.self)
                }
                letterResult.append(contentsOf: letters)
            }
            letterResult.sort { $0.date > $1.date }
            
            return .success(letterResult)
        } catch {
            logger.error("Search Letter Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    func searchByDate(
        userId: String,
        startDate: Date,
        endDate: Date,
        letterType: [String]
    ) async -> Result<[Letter]?, any Error> {
        do {
            var letterResult: [Letter] = []
            
            for type in letterType {
                let snapshot = try await db.collection("Writers")
                    .document(userId)
                    .collection(type)
                    .whereField("date", isGreaterThan: startDate)
                    .whereField("date", isLessThan: endDate)
                    .order(by: "date", descending: true)
                    .getDocuments()
                
                let letters = try snapshot.documents.compactMap { document in
                    try document.data(as: Letter.self)
                }
                letterResult.append(contentsOf: letters)
            }
            letterResult.sort { $0.date > $1.date }
            
            return .success(letterResult)
        } catch {
            logger.error("Search Letter Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    func removeLetter(
        userId: String,
        letterId: String,
        letterType: [String]
    ) async -> Result<Bool, any Error> {
        var removeSucceeded = false
        
        do {
            for type in letterType {
                let documentRef = db.collection("Writers")
                    .document(userId)
                    .collection(type)
                    .document(letterId)
                
                let documentSnapshot = try await documentRef.getDocument()
                
                if documentSnapshot.exists {
                    try await validateLetter(userId: userId, letterId: letterId, letterType: type)
                    
                    try await documentRef.delete()
                    removeSucceeded = true
                } else {
                    logger.error("Document does not exist in \(type) collection.")
                }
            }
            
            if removeSucceeded {
                return .success(true)
            } else {
                logger.error("Letter Delete Failed: \(LetterError.invalidLetterId)")
                return .failure(LetterError.invalidLetterId)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func updateIsRead(
        userId: String,
        letterId: String,
        letterType: [String]
    ) async -> Result<Bool, any Error> {
        var updateSucceeded = false
        
        do {
            for type in letterType {
                let documentRef = db.collection("Writers")
                    .document(userId)
                    .collection(type)
                    .document(letterId)
                
                let documentSnapshot = try await documentRef.getDocument()
                
                if documentSnapshot.exists {
                    try await documentRef.setData(["isRead": true], merge: true)
                    updateSucceeded = true
                } else {
                    logger.error("Document does not exist in \(type) collection.")
                }
            }
            
            if updateSucceeded {
                return .success(true)
            } else {
                logger.error("IsRead Update Failed: \(LetterError.invalidLetterId)")
                return .failure(LetterError.invalidLetterId)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func getIsReadCount(userId: String) -> AnyPublisher<[LetterType: Int], Never> {
        let typeToCollectionName: [LetterType: String] = [
            .toMe: "ToMe",
            .received: "Received"
        ]
        
        let publishers = typeToCollectionName.map { type, collectionName in
            createUnreadCountPublisher(userId: userId, type: type, collectionName: collectionName)
        }
        
        return Publishers.MergeMany(publishers)
            .scan([LetterType: Int]()) { accumulated, new in
                var updated = accumulated
                updated.merge(new) { _, new in new }
                updated[.all] = (updated[.toMe] ?? 0) + (updated[.received] ?? 0)
                return updated
            }
            .eraseToAnyPublisher()
    }
    
    private func createUnreadCountPublisher(
        userId: String,
        type: LetterType,
        collectionName: String
    ) -> AnyPublisher<[LetterType: Int], Never> {
        let subject = PassthroughSubject<[LetterType: Int], Never>()
        
        let listener = db.collection("Writers")
            .document(userId)
            .collection(collectionName)
            .whereField("isRead", isEqualTo: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.logger.error("Failed to get Count: \(error.localizedDescription)")
                    subject.send([type: 0])
                    return
                }
                
                let count = querySnapshot?.documents.count ?? 0
                subject.send([type: count])
            }
        
        return subject
            .handleEvents(receiveCancel: {
                listener.remove()
            })
            .eraseToAnyPublisher()
    }
    
    func getWelcomeLetter(userId: String) async -> Result<Bool, any Error> {
        do {
            let querySnapshot = try await db.collection("WelcomeLetter").getDocuments()
            
            for document in querySnapshot.documents {
                var letterData = document.data()
                letterData["date"] = Timestamp(date: Date())
                
                try await db.collection("Writers")
                    .document(userId)
                    .collection("Received")
                    .addDocument(data: letterData)
            }
            return .success(true)
        } catch {
            logger.error("Failed to get Welcome Letter: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    func findDocuments<T: Codable>(
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
