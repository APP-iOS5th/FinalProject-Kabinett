//
//  LetterBoxViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/22/24.
//

import SwiftUI

enum LetterBoxType: String, CaseIterable, Identifiable {
    case All = "전체 편지"
    case Tome = "나에게 보낸 편지"
    case Sent = "보낸 편지"
    case Recieved = "받은 편지"
    
    var id: String { self.rawValue }
    
    func toLetterType() -> LetterType {
            switch self {
            case .All:
                return .all
            case .Tome:
                return .toMe
            case .Sent:
                return .sent
            case .Recieved:
                return .received
            }
        }
    
    func setEmptyMessage() -> String {
        switch self {
        case .All:
            return "아직 편지가 없어요."
        case .Tome:
            return "아직 나에게 보낸 편지가 없어요."
        case .Sent:
            return "아직 보낸 편지가 없어요."
        case .Recieved:
            return "아직 받은 편지가 없어요."
        }
    }
}

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
