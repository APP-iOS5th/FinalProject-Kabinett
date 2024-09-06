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
        let userId: String
        
        do {
            userId = try await letterManager.getCurrentUserId()
        } catch {
            logger.error("Failed Get Writer: \(error.localizedDescription)")
            return .failure(error)
        }
        
        switch letterType {
        case .sent:
            return await letterManager.getLetters(
                userId: userId,
                letterType: ["Sent"]
            )
        case .received:
            return await letterManager.getLetters(
                userId: userId,
                letterType: ["Received"]
            )
        case .toMe:
            return await letterManager.getLetters(
                userId: userId,
                letterType: ["ToMe"]
            )
        case .all:
            return await letterManager.getLetters(
                userId: userId,
                letterType: ["Sent", "ToMe", "Received"]
            )
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
                logger.error("Failed getLetterBoxLetters: \(error.localizedDescription)")
                return .failure(error)
            }
        }
        return .success(result)
    }
    
    // 안읽은 letter 개수 로딩
    func getIsRead() async -> Result<[LetterType: Int], any Error> {
        do {
            let userId = try await letterManager.getCurrentUserId()
            return await letterManager.getIsReadCount(userId: userId)
        } catch {
            logger.error("Failed Get Writer: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    // keyword 기준 letter 검색
    func searchBy(
        findKeyword: String,
        letterType: LetterType
    ) async -> Result<[Letter]?, any Error> {
        let userId: String
        
        do {
            userId = try await letterManager.getCurrentUserId()
        } catch {
            logger.error("Failed Get Writer: \(error.localizedDescription)")
            return .failure(error)
        }
        
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
        let userId: String
        
        do {
            userId = try await letterManager.getCurrentUserId()
        } catch {
            logger.error("Failed Get Writer: \(error.localizedDescription)")
            return .failure(error)
        }
        
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
        let userId: String
        
        do {
            userId = try await letterManager.getCurrentUserId()
        } catch {
            logger.error("Failed Get Writer: \(error.localizedDescription)")
            return .failure(error)
        }
        
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
        let userId: String
        
        do {
            userId = try await letterManager.getCurrentUserId()
        } catch {
            logger.error("Failed Get Writer: \(error.localizedDescription)")
            return .failure(error)
        }
        
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
        do {
            let userId = try await letterManager.getCurrentUserId()
            return await letterManager.getWelcomeLetter(userId: userId)
        } catch {
            logger.error("Failed Get Writer: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
