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
    
    func fetchLetterBoxLetters() {
        Task { @MainActor in
            let result = await letterBoxUseCase.getLetterBoxLetters()
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
    
    func calculateOffsetAndRotation(for index: Int, totalCount: Int) -> (xOffset: CGFloat, yOffset: CGFloat, rotation: Double) {
        switch totalCount {
        case 1:
            return (xOffset: CGFloat(-6.5), yOffset: CGFloat(-1.5), rotation: Double(-1.5))
        case 2:
            let xOffset = index == 0 ? -7 : 6
            let yOffset = index == 0 ? -10 : -2
            let rotation = index == 0 ? -1 : 0
            return (xOffset: CGFloat(xOffset), yOffset: CGFloat(yOffset), rotation: Double(rotation))
        case 3:
            let xOffset = [-12, -5, 12][index]
            let yOffset = [-3, -12, -2][index]
            return (xOffset: CGFloat(xOffset), yOffset: CGFloat(yOffset), rotation: 0)
        default:
            return (xOffset: 0, yOffset: 0, rotation: 0)
        }
    }
}

extension LetterType {
    var description: String {
            switch self {
            case .all:
                return "All"
            case .toMe:
                return "To me"
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
