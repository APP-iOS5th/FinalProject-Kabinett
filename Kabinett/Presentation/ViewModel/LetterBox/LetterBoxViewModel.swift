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
    
    @Published var isSEDevice: Bool = false
    private let baseWidth: CGFloat = 390 // iPhone 15 Pro 의 논리적 너비
    
    init(letterBoxUseCase: LetterBoxUseCase) {
        self.letterBoxUseCase = letterBoxUseCase
        checkDevice()
    }
    
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
    
    func fetchWelcomeLetter() {
        Task { @MainActor in
            _ = await letterBoxUseCase.getWelcomeLetter()
        }
    }
    
    func calculateOffsetAndRotation(for index: Int, totalCount: Int) -> (xOffset: CGFloat, yOffset: CGFloat, rotation: Double) {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            switch totalCount {
            case 1:
                return (xOffset: screenWidth * -0.017, yOffset: screenHeight * -0.002, rotation: Double(-1.5))
            case 2:
                let xOffset = index == 0 ? screenWidth * -0.018 : screenWidth * 0.015
                let yOffset = index == 0 ? screenHeight * -0.01 : screenHeight * -0.001
                let rotation = index == 0 ? -1 : 0
                return (xOffset: xOffset, yOffset: yOffset, rotation: Double(rotation))
            case 3:
                let xOffsets = [screenWidth * -0.029, screenWidth * -0.02, screenWidth * 0.029]
                let yOffsets = [screenHeight * -0.002, screenHeight * -0.01, screenHeight * -0.002]
                return (xOffset: xOffsets[index], yOffset: yOffsets[index], rotation: 0)
            default:
                return (xOffset: 0, yOffset: 0, rotation: 0)
            }
    }
    
    func checkDevice() {
        let deviceName = UIDevice.current.name
        isSEDevice = deviceName.contains("SE")
    }
    
    // 헬퍼 함수들
    func getWidth(forSE: CGFloat, forOthers: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width * (isSEDevice ? forSE : forOthers)
    }
    
    func getSize(forSE: CGFloat, forOthers: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.height * (isSEDevice ? forSE : forOthers)
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
