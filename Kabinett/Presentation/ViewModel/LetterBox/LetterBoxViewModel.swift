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
    @Published var showToast = false
    
    @Published var errorMessage: String?
    private var letterTask: Task<Void, Never>?
    private var isReadTask: Task<Void, Never>?
    
    init(letterBoxUseCase: LetterBoxUseCase) {
        self.letterBoxUseCase = letterBoxUseCase
        fetchLetterBoxLetters()
        fetchIsRead()
    }
    
    func fetchLetterBoxLetters() {
        letterTask?.cancel()
        letterTask = Task { @MainActor in
            for await letters in letterBoxUseCase.getLetterBoxLetters() {
                if Task.isCancelled { break }
                self.letterBoxLetters.merge(letters) { _, new in new }
            }
        }
    }
    
    func getSomeLetters(for type: LetterType) -> [Letter] {
        return letterBoxLetters[type] ?? []
    }
    
    func fetchIsRead() {
        isReadTask?.cancel()
        isReadTask = Task { @MainActor in
            for await letterCount in letterBoxUseCase.getIsRead() {
                if Task.isCancelled { break }
                self.isReadLetters = letterCount
            }
        }
    }
    
    func getIsReadLetters(for type: LetterType) -> Int {
        return isReadLetters[type] ?? 0
    }
    
    func fetchWelcomeLetter() {
        Task { @MainActor in
            let result = await letterBoxUseCase.getWelcomeLetter()
            switch result {
            case .success:
                self.showToast = true
            case .failure(let error):
                self.showToast = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    deinit {
        letterTask?.cancel()
        isReadTask?.cancel()
    }
}
