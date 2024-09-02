//
//  LetterBoxDetailViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/25/24.
//

import SwiftUI

class LetterBoxDetailViewModel: ObservableObject {
    private let letterBoxUseCase: LetterBoxUseCase
    
    init(letterBoxUseCase: LetterBoxUseCase) {
        self.letterBoxUseCase = letterBoxUseCase
    }
    
    @Published var letterBoxDetailLetters: [Letter] = []
    
    @Published var errorMessage: String?
    
    func fetchLetterBoxDetailLetters(letterType: LetterType) {
        Task { @MainActor in
            let result = await letterBoxUseCase.getLetterBoxDetailLetters(letterType: letterType)
            switch result {
            case .success(let letterArray):
                self.letterBoxDetailLetters = letterArray
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchSearchByKeyword(findKeyword: String, letterType: LetterType) {
        if findKeyword.isEmpty { return }
        
        Task { @MainActor in
            let result = await letterBoxUseCase.searchBy(findKeyword: findKeyword, letterType: letterType)
            switch result {
            case .success(let resultLettersOfSearchKeyword):
                self.letterBoxDetailLetters = resultLettersOfSearchKeyword ?? []
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchSearchByDate(letterType: LetterType, startDate: Date, endDate: Date) {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: startDate)
        let endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate)) ?? endDate
        
        Task { @MainActor in
            let result = await letterBoxUseCase.searchBy(letterType: letterType, startDate: startDate, endDate: endDate)
            switch result {
            case .success(let resultLettersOfSearchDate):
                self.letterBoxDetailLetters = resultLettersOfSearchDate ?? []
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
