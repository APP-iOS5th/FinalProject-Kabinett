//
//  LetterBoxViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/22/24.
//

import SwiftUI

class LetterBoxViewModel: ObservableObject {
    private let letterBoxUseCase: LetterBoxUseCase
    
    init(letterBoxUseCase: LetterBoxUseCase = LetterBoxUseCaseStub()) {
        self.letterBoxUseCase = letterBoxUseCase
    }
    
    @Published var letterBoxLetters: [LetterType: [Letter]] = [:]
    @Published var isReadLetters: [LetterType: Int] = [:]
    
    @Published var errorMessage: String?
    
    func fetchLetterBoxLetters(for userId: String) {
        Task { @MainActor in
            let result = await letterBoxUseCase.getLetterBoxLetters(userId: userId)
            switch result {
            case .success(let letterDictionary):
                self.letterBoxLetters = letterDictionary
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getSomeLetters(for type: LetterType) -> [Letter] {
        return letterBoxLetters[type] ?? []
    }
    
    func fetchIsRead(for userId: String) {
        Task { @MainActor in
            let result = await letterBoxUseCase.getIsRead(userId: userId)
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
}

extension LetterType {
    var description: String {
            switch self {
            case .all:
                return "All"
            case .toMe:
                return "Tome"
            case .sent:
                return "Sent"
            case .received:
                return "Recieved"
            }
        }
    
    func koName() -> String {
        switch self {
        case .all:
            return "전체 편지"
        case .toMe:
            return "나에게 보낸 편지"
        case .sent:
            return "보낸 편지"
        case .received:
            return "받은 편지"
        }
    }
    
    func setEmptyMessage() -> String {
        switch self {
        case .all:
            return "아직 편지가 없어요."
        case .toMe:
            return "아직 나에게 보낸 편지가 없어요."
        case .sent:
            return "아직 보낸 편지가 없어요."
        case .received:
            return "아직 받은 편지가 없어요."
        }
    }
}
