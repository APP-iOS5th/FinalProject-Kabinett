//
//  DefaultLetterBoxUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 9/5/24.
//

import Foundation
import Combine
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
    
    func getLetterBoxDetailLetters(letterType: LetterType) -> AnyPublisher<[Letter], Never> {
        authManager.getCurrentUser()
            .compactMap { $0?.uid }
            .flatMap { userId in
                self.letterManager.getLetters(userId: userId, letterType: letterType.types)
            }
            .eraseToAnyPublisher()
    }
    
    func getLetterBoxLetters() -> AnyPublisher<[LetterType : [Letter]], Never> {
        let types: [LetterType] = [.all, .sent, .received, .toMe]
        
        let publishers = types.map { type in
            getLetterBoxDetailLetters(letterType: type)
                .map { letters in
                    [type: Array(letters.prefix(3))]
                }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { results in
                results.reduce(into: [LetterType: [Letter]]()) { combined, result in
                    combined.merge(result) { _, new in new }
                }
            }
            .eraseToAnyPublisher()
    }
    
    // 안읽은 letter 개수 로딩
    func getIsRead() -> AsyncStream<[LetterType: Int]> {
        return AsyncStream { continuation in
            Task {
                let userId = await self.authManager.getCurrentUser()?.uid ?? ""
                for try await result in self.letterManager.getIsReadCount(userId: userId) {
                    continuation.yield(result)
                }
                continuation.finish()
            }
        }
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
        if let currentUser = await authManager.getCurrentUser(), currentUser.isAnonymous {
            let userId = currentUser.uid
            return await letterManager.getWelcomeLetter(userId: userId)
        } else {
            return .failure(LetterError.identityUser)
        }
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
