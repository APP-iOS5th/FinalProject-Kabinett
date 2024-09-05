//
//  DefaultLetterBoxUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 9/5/24.
//

import Foundation
import FirebaseFirestore
import os

final class DefaultLetterBoxUseCase {
    private let logger: Logger
    private let letterManager: FirestoreLetterManager
    
    init(
        letterManager: FirestoreLetterManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultLetterBoxUseCase"
        )
        self.letterManager = letterManager
    }
}

extension DefaultLetterBoxUseCase: LetterBoxUseCase {
    // letter 타입별 로딩
    func getLetterBoxDetailLetters(letterType: LetterType) async -> Result<[Letter], any Error> {
        do {
            let userId = try await getCurrentUserId()
            
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
                var letterData = document.data()
                letterData["date"] = Timestamp(date: Date())
                
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
    
    
}
