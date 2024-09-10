//
//  DefaultLetterBoxUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 9/5/24.
//

import Foundation
import os

final class DefaultLetterBoxUseCase {
    private let logger: Logger
    private let letterManager: FirestoreLetterManager
    private let authManager: AuthManager
    
    init(
        letterManager: FirestoreLetterManager,
        authManager: AuthManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultLetterBoxUseCase"
        )
        self.letterManager = letterManager
        self.authManager = authManager
    }
}

extension DefaultLetterBoxUseCase: LetterBoxUseCase {
    
    // letter 타입별 로딩
    func getLetterBoxDetailLetters(letterType: LetterType) async -> AsyncStream<[Letter]> {
        let userId = await authManager.getCurrentUser()?.uid ?? ""
        
        return letterManager.getLetters(
            userId: userId,
            letterType: letterType.types
        )
    }
    
    // main 편지함 letter 3개 로딩
    func getLetterBoxLetters() -> AsyncStream<[LetterType: [Letter]]> {
        AsyncStream { continuation in
            Task {
                let types: [LetterType] = [.sent, .received, .toMe, .all]
                
                for type in types {
                    Task {
                        for await letters in await getLetterBoxDetailLetters(letterType: type) {
                            
                            let newResult = [type: Array(letters.prefix(3))]
                            continuation.yield(newResult)
                            
                        }
                    }
                }
            }
        }
    }

    
    // 안읽은 letter 개수 로딩
    func getIsRead() async -> Result<[LetterType: Int], any Error> {
        let userId = await authManager.getCurrentUser()?.uid ?? ""
        return await letterManager.getIsReadCount(userId: userId)
    }
    
    // keyword 기준 letter 검색
    func searchBy(
        findKeyword: String,
        letterType: LetterType
    ) async -> Result<[Letter]?, any Error> {
        let userId = await authManager.getCurrentUser()?.uid ?? ""
        
        switch letterType {
        case .sent:
            return await letterManager.searchByKeyword(
                userId: userId,
                keyword: findKeyword,
                letterType: ["Sent"]
            )
        case .received:
            return await letterManager.searchByKeyword(
                userId: userId,
                keyword: findKeyword,
                letterType: ["Received"]
            )
        case .toMe:
            return await letterManager.searchByKeyword(
                userId: userId,
                keyword: findKeyword,
                letterType: ["ToMe"]
            )
        case .all:
            return await letterManager.searchByKeyword(
                userId: userId,
                keyword: findKeyword,
                letterType: ["Sent", "ToMe", "Received"]
            )
        }
    }
    
    // date 기준 letter 검색
    func searchBy(
        letterType: LetterType,
        startDate: Date,
        endDate: Date
    ) async -> Result<[Letter]?, any Error> {
        let userId = await authManager.getCurrentUser()?.uid ?? ""
        
        switch letterType {
        case .sent:
            return await letterManager.searchByDate(
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                letterType: ["Sent"]
            )
        case .received:
            return await letterManager.searchByDate(
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                letterType: ["Received"]
            )
        case .toMe:
            return await letterManager.searchByDate(
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                letterType: ["ToMe"]
            )
        case .all:
            return await letterManager.searchByDate(
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                letterType: ["Sent", "ToMe", "Received"]
            )
        }
    }
    
    // letter 삭제
    func removeLetter(
        letterId: String,
        letterType: LetterType
    ) async -> Result<Bool, any Error> {
        let userId = await authManager.getCurrentUser()?.uid ?? ""
        
        switch letterType {
        case .sent:
            return await letterManager.removeLetter(
                userId: userId,
                letterId: letterId,
                letterType: ["Sent"]
            )
        case .received:
            return await letterManager.removeLetter(
                userId: userId,
                letterId: letterId,
                letterType: ["Received"]
            )
        case .toMe:
            return await letterManager.removeLetter(
                userId: userId,
                letterId: letterId,
                letterType: ["ToMe"]
            )
        case .all:
            return await letterManager.removeLetter(
                userId: userId,
                letterId: letterId,
                letterType: ["Sent", "Received", "ToMe"]
            )
        }
    }
    
    // 안읽음 -> 읽음 update
    func updateIsRead(
        letterId: String,
        letterType: LetterType
    ) async -> Result<Bool, any Error> {
        let userId = await authManager.getCurrentUser()?.uid ?? ""
        
        switch letterType {
        case .sent:
            return await letterManager.updateIsRead(
                userId: userId,
                letterId: letterId,
                letterType: ["Sent"]
            )
        case .received:
            return await letterManager.updateIsRead(
                userId: userId,
                letterId: letterId,
                letterType: ["Received"]
            )
        case .toMe:
            return await letterManager.updateIsRead(
                userId: userId,
                letterId: letterId,
                letterType: ["ToMe"]
            )
        case .all:
            return await letterManager.updateIsRead(
                userId: userId,
                letterId: letterId,
                letterType: ["Sent", "Received", "ToMe"]
            )
        }
    }
    
    func getWelcomeLetter() async -> Result<Bool, any Error> {
        let userId = await authManager.getCurrentUser()?.uid ?? ""
        return await letterManager.getWelcomeLetter(userId: userId)
    }
}

extension LetterType {
    var types: [String] {
        switch self {
        case .sent: return ["Sent"]
        case .received: return ["Received"]
        case .toMe: return ["ToMe"]
        case .all: return ["Sent", "Received", "ToMe"]
        }
    }
}
