//
//  LetterViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/28/24.
//

import Foundation

class LetterViewModel: ObservableObject {
    private let letterBoxUseCase: LetterBoxUseCase
    
    init(letterBoxUseCase: LetterBoxUseCase = LetterBoxUseCaseStub()) {
        self.letterBoxUseCase = letterBoxUseCase
    }
    
    @Published var isRemove: Bool = false
    @Published var isRead: Bool = false
    
    @Published var errorMessage: String?
    
    func deleteLetter(letterId: String, letterType: LetterType) {
        Task { @MainActor in
            let result = await letterBoxUseCase.removeLetter(letterId: letterId, letterType: letterType)
            switch result {
            case .success(let isRemove):
                self.isRemove = isRemove
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func updateLetterReadStatus(letterId: String, letterType: LetterType) {
        Task { @MainActor in
            let result = await letterBoxUseCase.updateIsRead(letterId: letterId, letterType: letterType)
            switch result {
            case .success(let isRead):
                self.isRead = isRead
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
