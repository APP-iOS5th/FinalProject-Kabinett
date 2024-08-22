//
//  LetterBoxViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/22/24.
//

//import Combine
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
}

class LetterBoxViewModel: ObservableObject {
    private let letterBoxUseCase: LetterBoxUseCase
//    private var cancellables = Set<AnyCancellable>()
    
    init(letterBoxUseCase: LetterBoxUseCase = MockLetterBoxUseCase()) {
        self.letterBoxUseCase = letterBoxUseCase
        self.letterBoxLetters = LetterBoxViewModel.sampleLetterDictionary
        self.letterBoxDetailLetters = LetterBoxViewModel.sampleLetters
    }
    
    @Published var letterBoxLetters: [LetterType: [Letter]] = [:]
    @Published var letterBoxDetailLetters: [Letter] = []
    
    @Published var errorMessage: String?
    
    static var sampleLetters: [Letter] {
        return [
            Letter(id: UUID().uuidString, fontString: nil, postScript: "토마토 좀 보내줄까? 올해 맛있다 🍅", envelopeImageUrlString: "https://example.com/image1.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2021/08/19/05/18/tomatoes-6557067_1280.jpg", fromUserId: "user1", fromUserName: "Yule", fromUserKabinettNumber: 123, toUserId: "user2", toUserName: "Rei", toUserKabinettNumber: 456, content: "Sample content 1", photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: false),
            Letter(id: UUID().uuidString, fontString: nil, postScript: "Can I see you in this weekend", envelopeImageUrlString: "https://example.com/image2.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2020/04/08/10/41/full-moon-5016871_1280.jpg", fromUserId: "user3", fromUserName: "MIMI", fromUserKabinettNumber: 789, toUserId: "user4", toUserName: "Yule", toUserKabinettNumber: 101, content: "Sample content 2", photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: true)
        ]
    }
    
    static var sampleLetterDictionary: [LetterType: [Letter]] {
        return [
            .sent: sampleLetters,
            .received: sampleLetters,
            .toMe: sampleLetters,
            .all: sampleLetters
        ]
    }
    
    // func getLetterBoxLetters
    func fetchLetterBoxLetters(for userId: String) {
        Task {
            let result = await letterBoxUseCase.getLetterBoxLetters(userId: userId)
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let letterDictionary):
                    self?.letterBoxLetters = letterDictionary
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func getSomeLetters(for type: LetterType) -> [Letter] {
        return letterBoxLetters[type] ?? []
    }
    
    
    // func getLetterBoxDetailLetters
    func fetchLetterBoxDetailLetters(for userId: String, letterType: LetterType) {
        Task {
            let result = await letterBoxUseCase.getLetterBoxDetailLetters(userId: userId, letterType: letterType)
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let letter):
                    self?.letterBoxDetailLetters = letter
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func getAllLetters(for type: LetterType) -> [Letter] {
        return letterBoxDetailLetters
    }
}
