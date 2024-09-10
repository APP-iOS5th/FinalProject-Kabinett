//
//  LetterBoxViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/22/24.
//

import SwiftUI

class LetterBoxViewModel: ObservableObject {
    private let letterBoxUseCase: LetterBoxUseCase
    
    @Published var letterBoxLetters: [LetterType: [Letter]] = [:]
    @Published var isReadLetters: [LetterType: Int] = [:]
    
    @Published var errorMessage: String?
    private var task: Task<Void, Never>?
    
    init(letterBoxUseCase: LetterBoxUseCase) {
        self.letterBoxUseCase = letterBoxUseCase
        fetchLetterBoxLetters()
    }
    
    func fetchLetterBoxLetters() {
        task = Task { @MainActor in
            for await letters in letterBoxUseCase.getLetterBoxLetters() {
                self.letterBoxLetters.merge(letters) { _, new in new }
            }
        }
    }
    
    func getSomeLetters(for type: LetterType) -> [Letter] {
        return letterBoxLetters[type] ?? []
    }
    
    func fetchIsRead() {
        Task { @MainActor in
            let result = await letterBoxUseCase.getIsRead()
            switch result {
            case .success(let isReadDictionary):
                self.isReadLetters = isReadDictionary
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getIsReadLetters(for type: LetterType) -> Int {
        return isReadLetters[type] ?? 0
    }
    
    func fetchWelcomeLetter() {
        Task { @MainActor in
            _ = await letterBoxUseCase.getWelcomeLetter()
        }
    }
    
    deinit {
        task?.cancel()
    }
}
