//
//  LetterBoxDetailViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/25/24.
//

import SwiftUI
import Combine
import os

class LetterBoxDetailViewModel: ObservableObject {
    private let logger: Logger
    
    private let letterBoxUseCase: LetterBoxUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        letterBoxUseCase: LetterBoxUseCase
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "LetterBoxDetailViewModel"
        )
        self.letterBoxUseCase = letterBoxUseCase
    }
    
    @Published var letterBoxDetailLetters: [Letter] = []
    @Published var errorMessage: String?
    
    @Published var currentLetterType: LetterType = .all
    
    func fetchLetterBoxDetailLetters(letterType: LetterType) {
        letterBoxUseCase.getLetterBoxDetailLetters(letterType: letterType)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.logger.error("Receive letter Failed! \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] letters in
                self?.letterBoxDetailLetters = letters
            })
            .store(in: &cancellables)
    }
    
    func fetchSearchByKeyword(findKeyword: String, letterType: LetterType) {
        if findKeyword.isEmpty { return }
        
        Task { @MainActor in
            let result = await letterBoxUseCase.searchBy(findKeyword: findKeyword.lowercased(), letterType: letterType)
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
