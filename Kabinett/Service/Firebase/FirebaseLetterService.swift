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
    case invalidFromUserName
    case invalidToUserName
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
    
    // MARK: - LetterWriteUseCase
    func saveLetter(font: String, postScript: String?, envelope: String, stamp: String,
                    fromUserId: String?, fromUserName: String, fromUserKabinettNumber: Int?,
                    toUserId: String?, toUserName: String, toUserKabinettNumber: Int?,
                    content: String?, photoContents: [String], date: Date, stationery: String, isRead: Bool) async -> Result<Void, any Error> {
        
        // Parameter 유효성 검사
        guard !font.isEmpty else { return .failure(LetterError.invalidFont) }
        guard !envelope.isEmpty else { return .failure(LetterError.invalidEnvelope) }
        guard !stamp.isEmpty else { return .failure(LetterError.invalidStamp) }
        guard !fromUserName.isEmpty else { return .failure(LetterError.invalidFromUserName) }
        guard !toUserName.isEmpty else { return .failure(LetterError.invalidToUserName) }
        guard !stationery.isEmpty else { return .failure(LetterError.invalidStationery) }
        
        do {
            try await validateFromUser(fromUserId: fromUserId)
            
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
    
    // MARK: - ComponentsUseCase
    func saveLetter(postScript: String?, envelope: String, stamp: String,
                    fromUserId: String?, fromUserName: String, fromUserKabinettNumber: Int?,
                    toUserId: String?, toUserName: String, toUserKabinettNumber: Int?,
                    photoContents: [String], date: Date, isRead: Bool) async -> Result<Void, any Error> {
        
        // Parameter 유효성 검사
        guard !envelope.isEmpty else { return .failure(LetterError.invalidEnvelope) }
        guard !stamp.isEmpty else { return .failure(LetterError.invalidStamp) }
        guard !fromUserName.isEmpty else { return .failure(LetterError.invalidFromUserName) }
        guard !toUserName.isEmpty else { return .failure(LetterError.invalidToUserName) }
        guard !photoContents.isEmpty else { return .failure(LetterError.invalidPhotoContents) }
        
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
            content: nil,
            photoContents: photoContents,
            date: date,
            stationeryImageUrlString: nil,
            isRead: isRead)
        
        return await saveLetterToFireStore(letter: letter, fromUserId: fromUserId, toUserId: toUserId)
    }
    
    // MARK: - LetterBoxUseCase
    // letter 타입별 로딩
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
            let letters = try snapshot.documents.compactMap { document in
                try document.data(as: Letter.self)
            }
            
            return .success(letters)
        } catch {
            return .failure(error)
        }
    }
    
    // main 편지함 letter 3개 로딩
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
    
    // 안읽은 letter 개수 로딩
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
    
    // keyword 기준 letter 검색
    func searchBy(userId: String, findKeyword: String, letterType: LetterType) async -> Result<[Letter]?, any Error> {
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
                
                let query = collectionRef.whereFilter(Filter.orFilter([
                    Filter.whereField("toUserName", isEqualTo: findKeyword),
                    Filter.whereField("fromUserName", isEqualTo: findKeyword),
                    Filter.whereField("toUserKabinettNumber", isEqualTo: Int(findKeyword) ?? -1),
                    Filter.whereField("fromUserKabinettNumber", isEqualTo: Int(findKeyword) ?? -1)
                ]))
                
                let snapshot = try await query.getDocuments()
                
                let fetchedLetters = try snapshot.documents.compactMap { document in
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
    
    // date 기준 letter 검색
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
    
    // letter 삭제
    func removeLetter(userId: String, letterId: String, letterType: LetterType) async -> Result<Bool, any Error> {
        // TODO: - letter 삭제 구현
        fatalError()
    }
    
    // 안읽음->읽음 update
    func updateIsRead(userId: String, letterId: String, letterType: LetterType) async -> Result<Bool, any Error> {
        // TODO: - isRead update 구현
        fatalError()
    }
    
    // MARK: - 유저 유효성 검사
    private func validateFromUser(fromUserId: String?) async throws {
        let fromUserDoc = fromUserId.flatMap { !$0.isEmpty ? db.collection("Writers").document($0) : nil }
        
        let fromUserSnapshot = fromUserDoc != nil ? try await fromUserDoc!.getDocument() : nil
        guard let fromUserSnapshot = fromUserSnapshot, fromUserSnapshot.exists else { throw LetterSaveError.invalidFromUserDoc }
    }
    
    // MARK: - Firestore Letter 저장
    private func saveLetterToFireStore(letter: Letter, fromUserId: String?, toUserId: String?) async -> Result<Void, any Error> {
        
        do {
            let fromUserDoc = fromUserId.flatMap { !$0.isEmpty ? db.collection("Writers").document($0) : nil }
            let toUserDoc = toUserId.flatMap { !$0.isEmpty ? db.collection("Writers").document($0) : nil }
            
            let fromUserSnapshot = fromUserDoc != nil ? try await fromUserDoc!.getDocument() : nil
            let toUserSnapshot = toUserDoc != nil ? try await toUserDoc!.getDocument() : nil
            
            // fromUser가 존재하고, fromUserId와 toUserId가 같은 경우 -> ToMe
            if let fromUserSnapshot = fromUserSnapshot, fromUserSnapshot.exists && fromUserId == toUserId {
                do {
                    let letterData = try Firestore.Encoder().encode(letter)
                    try await fromUserDoc!.collection("ToMe").addDocument(data: letterData)
                    return .success(())
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
                    
                    let letterSentData = try Firestore.Encoder().encode(sentLetter)
                    try await fromUserDoc!.collection("Sent").addDocument(data: letterSentData)
                } catch {
                    sentSaveError = error
                }
                
                do {
                    let letterData = try Firestore.Encoder().encode(letter)
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
                return .success(())
                // fromUser가 존재하고, toUser가 존재하지 않을 때 -> Sent
            } else if let fromUserSnapshot = fromUserSnapshot, fromUserSnapshot.exists,
                      toUserSnapshot == nil || !toUserSnapshot!.exists {
                do {
                    var sentLetter = letter
                    sentLetter.isRead = true
                    
                    let letterSentData = try Firestore.Encoder().encode(sentLetter)
                    try await fromUserDoc!.collection("Sent").addDocument(data: letterSentData)
                    return .success(())
                } catch {
                    return .failure(LetterSaveError.failedToSaveSent)
                }
                // fromUser가 존재하지 않고, toUser가 존재할 때 -> Received
            } else if fromUserSnapshot == nil || !fromUserSnapshot!.exists,
                      let toUserSnapshot = toUserSnapshot, toUserSnapshot.exists {
                do {
                    let letterData = try Firestore.Encoder().encode(letter)
                    try await toUserDoc!.collection("Received").addDocument(data: letterData)
                    return .success(())
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
                let snapshot = try await db.collection("Writers").document(userId).collection(name).getDocuments()
                let letters = try snapshot.documents.compactMap { document in
                    try document.data(as: Letter.self)
                }
                allLetters.append(contentsOf: letters)
            }
            
            return .success(allLetters)
        } catch {
            return .failure(error)
        }
    }
}
