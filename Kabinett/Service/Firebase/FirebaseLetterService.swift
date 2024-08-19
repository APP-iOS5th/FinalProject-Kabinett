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
    case bothUsersNotFound
}

final class FirebaseLetterService: LetterWriteUseCase, ComponentsUseCase, LetterBoxUseCase {
    
    private let db = Firestore.firestore()
    
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
            try await validateFromUser(fromUserId: fromUserId)
            
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
    
    // ComponentsUseCase
    func saveLetter(postScript: String?, envelope: String, stamp: String, fromUserId: String, toUserId: String, photoContents: [String], date: Date, isRead: Bool) async -> Result<Void, any Error> {
        
        // MARK: - Parameter 유효성 검사
        guard !envelope.isEmpty else { return .failure(LetterError.invalidEnvelope) }
        guard !stamp.isEmpty else { return .failure(LetterError.invalidStamp) }
        guard !fromUserId.isEmpty else { return .failure(LetterError.invalidFromUserId) }
        guard !toUserId.isEmpty else { return .failure(LetterError.invalidToUserId) }
        guard !photoContents.isEmpty else { return .failure(LetterError.invalidPhotoContents) }
        
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
    }
    
    // LetterBoxUseCase
    func getLetterBoxDetailLetters(userId: String, letterType: LetterType) async -> Result<[Letter], any Error> {
        do {
            try await validateFromUser(fromUserId: userId)
            
            let collectionName: String
            switch letterType {
            case .sent:
                collectionName = "Sent"
            case .received:
                collectionName = "Received"
            case .toMe:
                collectionName = "ToMe"
            case .all:
                return await getAllLetters(userId: userId)
            }
            
            let snapshot = try await db.collection("Writers").document(userId).collection(collectionName).order(by: "date", descending: true).getDocuments()
            var letters = try snapshot.documents.compactMap { document in
                try document.data(as: Letter.self)
            }
            
            for index in letters.indices {
                let fromUserName = try await getUserName(userId: letters[index].fromUserId)
                let toUserName = try await getUserName(userId: letters[index].toUserId)
                letters[index].fromUserId = fromUserName
                letters[index].toUserId = toUserName
            }
            return .success(letters)
        } catch {
            return .failure(error)
        }
    }
    
    func getLetterBoxLetters(userId: String) async -> Result<[LetterType : [Letter]], any Error> {
        var result: [LetterType: [Letter]] = [:]
        
        for type in [LetterType.toMe, .sent, .received, .all] {
            let lettersResult = await getLetterBoxDetailLetters(userId: userId, letterType: type)
            
            switch lettersResult {
            case .success(let letters):
                result[type] = Array(letters.prefix(3))
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return .success(result)
    }
    
    func getIsRead(userId: String) async -> Result<[LetterType: Int], any Error> {
        var result: [LetterType: Int] = [:]
        
        let typeToCollectionName: [LetterType: String] = [
            .toMe: "ToMe",
            .received: "Received"
        ]
        
        do {
            try await validateFromUser(fromUserId: userId)
            
            for type in [LetterType.toMe, .received] {
                if let collectionName = typeToCollectionName[type] {
                    let collectionRef = db.collection("Writers").document(userId).collection(collectionName)
                    
                    let querySnapshot = try await collectionRef.whereField("isRead", isEqualTo: false).getDocuments()
                    result[type] = querySnapshot.documents.count
                }
            }
            result[.all] = (result[.toMe] ?? 0) + (result[.received] ?? 0)
            
            return .success(result)
        } catch {
            return .failure(error)
        }
        
    }
    
    func searchBy(userId: String, findKeyword: String, letterType: LetterType) async -> Result<[Letter]?, any Error> {
        // TODO: - 특정 키워드로 Letter 검색
        fatalError()
    }
    
    func searchBy(userId: String, letterType: LetterType, startDate: Date, endDate: Date) async -> Result<[Letter]?, any Error> {
        var letters: [Letter] = []
        
        do {
            try await validateFromUser(fromUserId: userId)
            
            let collectionNames: [String]
            switch letterType {
            case .sent:
                collectionNames = ["Sent"]
            case .received:
                collectionNames = ["Received"]
            case .toMe:
                collectionNames = ["ToMe"]
            case .all:
                collectionNames = ["Sent", "Received", "ToMe"]
            }
            
            for collectionName in collectionNames {
                let collectionRef = db.collection("Writers").document(userId).collection(collectionName)
                let querySnapshot = try await collectionRef.whereField("date", isGreaterThan: startDate)
                    .whereField("date", isLessThan: endDate)
                    .order(by: "date", descending: true)
                    .getDocuments()
                let fetchedLetters = try querySnapshot.documents.compactMap { document in
                    try document.data(as: Letter.self)
                }
                letters.append(contentsOf: fetchedLetters)
            }
            letters.sort { $0.date > $1.date }
            
            return .success(letters)
            
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - 유저 유효성 검사
    private func validateFromUser(fromUserId: String) async throws {
        let fromUserDoc = db.collection("Writers").document(fromUserId)
        
        let snapshotFrom = try await fromUserDoc.getDocument()
        guard snapshotFrom.exists else { throw LetterSaveError.invalidFromUserDoc }
    }
    
    private func validateToUser(toUserId: String) async throws {
        let toUserDoc = db.collection("Writers").document(toUserId)
        
        let snapshotTo = try await toUserDoc.getDocument()
        guard snapshotTo.exists else { throw LetterSaveError.invalidToUserDoc }
    }
    
    private func getUserName(userId: String) async throws -> String {
        let userDoc = db.collection("Writers").document(userId)
        
        let snapshotUser = try await userDoc.getDocument()
        
        if snapshotUser.exists, let data = snapshotUser.data(), let name = data["name"] as? String {
            return name
        } else {
            return userId
        }
    }
    
    // MARK: - Firestore Letter 저장
    private func saveLetterToFireStore(letter: Letter, fromUserId: String, toUserId: String) async -> Result<Void, any Error> {
        
        do {
            let fromUserDoc = db.collection("Writers").document(fromUserId)
            let toUserDoc = db.collection("Writers").document(toUserId)
            
            let fromUserSnapshot = try await fromUserDoc.getDocument()
            let toUserSnapshot = try await toUserDoc.getDocument()
            
            let letterData = try Firestore.Encoder().encode(letter)

            if fromUserSnapshot.exists && fromUserId == toUserId {
                do {
                    try await fromUserDoc.collection("ToMe").addDocument(data: letterData)
                    return .success(())
                } catch {
                    return .failure(LetterSaveError.failedToSaveToMe)
                }
            } else if fromUserSnapshot.exists && toUserSnapshot.exists && fromUserId != toUserId {
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
                
            } else if fromUserSnapshot.exists && !toUserSnapshot.exists {
                do {
                    try await fromUserDoc.collection("Sent").addDocument(data: letterData)
                    return .success(())
                } catch {
                    return .failure(LetterSaveError.failedToSaveSent)
                }
            } else if !fromUserSnapshot.exists && toUserSnapshot.exists {
                do {
                    try await toUserDoc.collection("Received").addDocument(data: letterData)
                    return .success(())
                } catch {
                    return .failure(LetterSaveError.failedToSaveReceived)
                }
            } else {
                // 둘 다 nil인 경우
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
                let snapshot = try await db.collection("Writers").document(userId).collection(name).getDocuments()
                let letters = try snapshot.documents.compactMap { document in
                    try document.data(as: Letter.self)
                }
                allLetters.append(contentsOf: letters)
            }
            
            for index in allLetters.indices {
                let fromUserName = try await getUserName(userId: allLetters[index].fromUserId)
                let toUserName = try await getUserName(userId: allLetters[index].toUserId)
                allLetters[index].fromUserId = fromUserName
                allLetters[index].toUserId = toUserName
            }
            
            return .success(allLetters)
        } catch {
            return .failure(error)
        }
    }
}
