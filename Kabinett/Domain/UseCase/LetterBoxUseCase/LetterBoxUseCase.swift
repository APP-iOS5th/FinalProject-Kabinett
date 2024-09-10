//
//  LetterBoxUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/14/24.
//

import Foundation

protocol LetterBoxUseCase {
    func getLetterBoxLetters() -> AsyncStream<[LetterType: [Letter]]>
    
    func getLetterBoxDetailLetters(
        letterType: LetterType
    ) async -> AsyncStream<[Letter]>
    
    func getIsRead() async -> Result<[LetterType: Int], any Error>
    
    func searchBy(
        findKeyword: String,
        letterType: LetterType
    ) async -> Result<[Letter]?, any Error>
    func searchBy(
        letterType: LetterType,
        startDate: Date,
        endDate: Date
    ) async -> Result<[Letter]?, any Error>
    
    func removeLetter(
        letterId: String,
        letterType: LetterType
    ) async -> Result<Bool, any Error>
    
    func updateIsRead(
        letterId: String,
        letterType: LetterType
    ) async -> Result<Bool, any Error>
    
    func getWelcomeLetter() async -> Result<Bool, any Error>
}

enum LetterType: CaseIterable {
    case all
    case toMe
    case sent
    case received
}
