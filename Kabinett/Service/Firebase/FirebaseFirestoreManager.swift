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

final class FirebaseFirestoreManager: LetterWriteUseCase, ComponentsUseCase, LetterBoxUseCase {
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
    
    // MARK: - LetterWriteUseCase
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
        
        // Parameter 유효성 검사
        guard !font.isEmpty else { return .failure(LetterError.invalidFont) }
        guard !envelope.isEmpty else { return .failure(LetterError.invalidEnvelope) }
        guard !stamp.isEmpty else { return .failure(LetterError.invalidStamp) }
        guard !fromUserName.isEmpty else { return .failure(LetterError.invalidFromUserName) }
        guard !toUserName.isEmpty else { return .failure(LetterError.invalidToUserName) }
        guard !stationery.isEmpty else { return .failure(LetterError.invalidStationery) }
        
        do {
            try await validateFromUser(fromUserId: fromUserId)
            let photoContentStringUrl: [String]
            if !photoContents.isEmpty {
                photoContentStringUrl = try await convertPhotoToUrl(photoContents: photoContents)
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
            
            return await saveLetterToFireStore(letter: letter, fromUserId: fromUserId, toUserId: toUserId)
            
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - ComponentsUseCase
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
        
        // Parameter 유효성 검사
        guard !envelope.isEmpty else { return .failure(LetterError.invalidEnvelope) }
        guard !stamp.isEmpty else { return .failure(LetterError.invalidStamp) }
        guard !fromUserName.isEmpty else { return .failure(LetterError.invalidFromUserName) }
        guard !toUserName.isEmpty else { return .failure(LetterError.invalidToUserName) }
        guard !photoContents.isEmpty else { return .failure(LetterError.invalidPhotoContents) }
        
        do {
            let photoContentStringUrl = try await convertPhotoToUrl(photoContents: photoContents)
            
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
            
            return await saveLetterToFireStore(letter: letter, fromUserId: fromUserId, toUserId: toUserId)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - LetterBoxUseCase
    // letter 타입별 로딩
    func getLetterBoxDetailLetters(letterType: LetterType) async -> Result<[Letter], any Error> {
        do {
            let userId = try await getCurrentUserId()
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
            
            let snapshot = try await db.collection("Writers")
                .document(userId)
                .collection(collectionName)
                .order(by: "date", descending: true)
                .getDocuments()
            
            let letters = try snapshot.documents.compactMap { document in
                try document.data(as: Letter.self)
            }
            
            return .success(letters)
        } catch {
            return .failure(error)
        }
    }
    
    // main 편지함 letter 3개 로딩
    func getLetterBoxLetters() async -> Result<[LetterType : [Letter]], any Error> {
        var result: [LetterType: [Letter]] = [:]
        
        for type in [LetterType.toMe, .sent, .received, .all] {
            let lettersResult = await getLetterBoxDetailLetters(letterType: type)
            
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
    func getIsRead() async -> Result<[LetterType: Int], any Error> {
        var result: [LetterType: Int] = [:]
        
        let typeToCollectionName: [LetterType: String] = [
            .toMe: "ToMe",
            .received: "Received"
        ]
        
        do {
            let userId = try await getCurrentUserId()
            try await validateFromUser(fromUserId: userId)
            
            for type in [LetterType.toMe, .received] {
                if let collectionName = typeToCollectionName[type] {
                    let collectionRef = db.collection("Writers")
                        .document(userId)
                        .collection(collectionName)
                    
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
    func searchBy(
        findKeyword: String,
        letterType: LetterType
    ) async -> Result<[Letter]?, any Error> {
        var letters: [Letter] = []
        
        do {
            let userId = try await getCurrentUserId()
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
                let collectionRef = db.collection("Writers")
                    .document(userId)
                    .collection(collectionName)
                
                let query = collectionRef
                    .whereField("searchUser", arrayContains: findKeyword)
                
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
    func searchBy(
        letterType: LetterType,
        startDate: Date,
        endDate: Date
    ) async -> Result<[Letter]?, any Error> {
        var letters: [Letter] = []
        
        do {
            let userId = try await getCurrentUserId()
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
                let collectionRef = db.collection("Writers")
                    .document(userId)
                    .collection(collectionName)
                
                let querySnapshot = try await collectionRef
                    .whereField("date", isGreaterThan: startDate)
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
    func removeLetter(
        letterId: String,
        letterType: LetterType
    ) async -> Result<Bool, any Error> {
        do {
            var removeSucceeded = false
            
            let userId = try await getCurrentUserId()
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
                do {
                    try await validateLetter(userId: userId, letterId: letterId, letterType: collectionName)
                    try await db.collection("Writers")
                        .document(userId)
                        .collection(collectionName)
                        .document(letterId)
                        .delete()
                    
                    removeSucceeded = true
                } catch {
                    
                }
            }
            
            if removeSucceeded {
                return .success(true)
            } else {
                return .failure(LetterError.invalidLetterId)
            }
        } catch {
            return .failure(error)
        }
    }
    
    // 안읽음->읽음 update
    func updateIsRead(
        letterId: String,
        letterType: LetterType
    ) async -> Result<Bool, any Error> {
        do {
            var updateSucceeded = false
            
            let userId = try await getCurrentUserId()
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
                collectionNames = ["Received", "ToMe"]
            }
            
            for collectionName in collectionNames {
                do {
                    try await validateLetter(userId: userId, letterId: letterId, letterType: collectionName)
                    try await db.collection("Writers")
                        .document(userId)
                        .collection(collectionName)
                        .document(letterId)
                        .setData(["isRead": true], merge: true)
                    
                    updateSucceeded = true
                } catch {
                    
                }
            }
            
            if updateSucceeded {
                return .success(true)
            } else {
                return .failure(LetterError.invalidLetterId)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func getWelcomeLetter() async -> Result<Bool, any Error> {
        do {
            let userId = try await getCurrentUserId()
            
            let querySnapshot = try await db.collection("WelcomeLetter").getDocuments()
            
            for document in querySnapshot.documents {
                let letterData = document.data()
                try await db.collection("Writers")
                    .document(userId)
                    .collection("Received")
                    .addDocument(data: letterData)
            }
            
            return .success(true)
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
    
    func getCurrentWriter() async -> Writer {
        if let user = authManager.getCurrentUser() {
            return await writerManager.getWriterDocument(with: user.uid)
        } else {
            return .anonymousWriter
        }
    }
    
    // MARK: - 유효성 검사
    private func validateFromUser(fromUserId: String?) async throws {
        let fromUserDoc = fromUserId.flatMap { !$0.isEmpty ? db.collection("Writers").document($0) : nil }
        
        let fromUserSnapshot = fromUserDoc != nil ? try await fromUserDoc!.getDocument() : nil
        guard let fromUserSnapshot = fromUserSnapshot, fromUserSnapshot.exists else { throw LetterSaveError.invalidFromUserDoc }
    }
    
    private func validateLetter(
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
    private func saveLetterToFireStore(
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
    private func convertPhotoToUrl(photoContents: [Data]) async throws -> [String] {
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
