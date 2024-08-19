//
//  LetterBoxUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/14/24.
//

import Foundation

protocol LetterBoxUseCase {
    func getLetterBoxLetters(userId: String) async -> Result<[LetterType: [Letter]], any Error>
    func getLetterBoxDetailLetters(userId: String, letterType: LetterType) async -> Result<[Letter], any Error>
    func getIsRead(userId: String) async -> Result<[LetterType: Int], any Error>
    
    func searchBy(userId: String, findKeyword: String, letterType: LetterType) async -> Result<[Letter]?, any Error>
    func searchBy(userId: String, letterType: LetterType, startDate: Date, endDate: Date) -> Result<[Letter]?, any Error>
}

enum LetterType {
    case sent
    case received
    case toMe
    case all
}
