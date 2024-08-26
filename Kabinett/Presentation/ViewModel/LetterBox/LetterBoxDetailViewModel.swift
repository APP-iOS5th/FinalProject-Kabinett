//
//  LetterBoxDetailViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/25/24.
//

import SwiftUI

class LetterBoxDetailViewModel: ObservableObject {
    private let letterBoxUseCase: LetterBoxUseCase
    
    init(letterBoxUseCase: LetterBoxUseCase = LetterBoxUseCaseStub()) {
        self.letterBoxUseCase = letterBoxUseCase
    }
    
    @Published var letterBoxDetailLetters: [Letter] = []
    @Published var isRemoveLetter: Bool = false
    
    @Published var errorMessage: String?
    
    func fetchLetterBoxDetailLetters(for userId: String, letterType: LetterType) {
        Task { @MainActor in
            let result = await letterBoxUseCase.getLetterBoxDetailLetters(userId: userId, letterType: letterType)
            switch result {
            case .success(let letterArray):
                self.letterBoxDetailLetters = letterArray
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func removeLetterBoxDetailLetter(for userId: String, letterId: String, letterType: LetterType) {
        Task { @MainActor in
            let result = await letterBoxUseCase.removeLetter(userId: userId, letterId: letterId, letterType: letterType)
            switch result {
            case .success(let isRemove):
                self.isRemoveLetter = isRemove
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
