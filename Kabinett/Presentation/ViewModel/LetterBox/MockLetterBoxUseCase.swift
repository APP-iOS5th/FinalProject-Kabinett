//
//  MockLetterBoxUseCase.swift
//  Kabinett
//
//  Created by uunwon on 8/22/24.
//

import Foundation

class MockLetterBoxUseCase: LetterBoxUseCase {
    func getLetterBoxLetters(userId: String) async -> Result<[LetterType: [Letter]], any Error> {
        return .success(LetterBoxViewModel.sampleLetterDictionary)
    }
    
    func getLetterBoxDetailLetters(userId: String, letterType: LetterType) async -> Result<[Letter], any Error> {
        return .success(LetterBoxViewModel.sampleLetters)
    }
    
    func getIsRead(userId: String) async -> Result<[LetterType : Int], any Error> {
        return .success(LetterBoxViewModel.sampleLetterIsRead)
    }
    
    func searchBy(userId: String, findKeyword: String, letterType: LetterType) async -> Result<[Letter]?, any Error> {
        return .success(LetterBoxViewModel.sampleLetters)
    }
    
    func searchBy(userId: String, letterType: LetterType, startDate: Date, endDate: Date) async -> Result<[Letter]?, any Error> {
        return .success(LetterBoxViewModel.sampleLetters)
    }
    
    func removeLetter(userId: String, letterId: String, letterType: LetterType) async -> Result<Bool, any Error> {
        return .success(true)
    }
    
    func updateIsRead(userId: String, letterId: String, letterType: LetterType) async -> Result<Bool, any Error> {
        return .success(true)
    }
}
