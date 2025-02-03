//
//  LetterBoxViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/22/24.
//

import SwiftUI
import Combine
import os

class LetterBoxViewModel: ObservableObject {
    private let logger: Logger
    private let letterBoxUseCase: LetterBoxUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var letterBoxLetters: [LetterType: [Letter]] = [:]
    @Published var isReadLetters: [LetterType: Int] = [:]
    @Published var isShowToast = false
    
    @Published var errorMessage: String?
    
    init(letterBoxUseCase: LetterBoxUseCase) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "LetterBoxViewModel"
        )
        self.letterBoxUseCase = letterBoxUseCase
        self.fetchLetterBoxLetters()
        self.fetchIsRead()
    }
    
    func fetchLetterBoxLetters() {
        letterBoxUseCase.getLetterBoxLetters()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.logger.error("Error fetching letters: \(error.localizedDescription)")
                    self.errorMessage = "편지 가져오기 오류: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] letters in
                self?.letterBoxLetters.merge(letters) { _, new in new }
            })
            .store(in: &cancellables)
    }
    
    func getSomeLetters(for type: LetterType) -> [Letter] {
        return letterBoxLetters[type] ?? []
    }
    
    func fetchIsRead() {
        letterBoxUseCase.getIsRead()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.logger.error("Error fetching letter counts: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] letterCount in
                self?.isReadLetters = letterCount
            })
            .store(in: &cancellables)
    }
    
    func getIsReadLetters(for type: LetterType) -> Int {
        return isReadLetters[type] ?? 0
    }
    
    func fetchWelcomeLetter() {
        Task { @MainActor in
            let result = await letterBoxUseCase.getWelcomeLetter()
            switch result {
            case .success:
                self.isShowToast = true
                NotificationCenter.default.post(
                    name: .showToast,
                    object: nil,
                    userInfo: ["message": "카비넷 팀이 보낸 편지가 도착했어요.", "color": Color.primary900])
            case .failure(let error):
                self.isShowToast = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
