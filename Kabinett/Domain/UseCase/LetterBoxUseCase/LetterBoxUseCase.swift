//
//  LetterBoxUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/14/24.
//

import Foundation
import Combine

protocol LetterBoxUseCase {
    func getLetterBoxLetters() -> AnyPublisher<[LetterType: [Letter]], Never>
    
    func getLetterBoxDetailLetters(
        letterType: LetterType
    ) -> AnyPublisher<[Letter], Never>
    
    func getIsRead() -> AnyPublisher<[LetterType: Int], Never>
    
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
