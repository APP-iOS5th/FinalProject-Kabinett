//
//  LetterBoxUseCaseStub.swift
//  Kabinett
//
//  Created by uunwon on 8/22/24.
//

import Foundation

class LetterBoxUseCaseStub: LetterBoxUseCase {
    static var sampleLetters: [Letter] {
        return [
            Letter(id: UUID().uuidString, fontString: nil, postScript: "토마토 좀 보내줄까? 올해 맛있다 🍅", envelopeImageUrlString: "https://example.com/image1.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2021/08/19/05/18/tomatoes-6557067_1280.jpg", fromUserId: "user1", fromUserName: "Yule", fromUserKabinettNumber: 123, toUserId: "user2", toUserName: "Rei", toUserKabinettNumber: 456, content: "Sample content 1", photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: false),
            Letter(id: UUID().uuidString, fontString: nil, postScript: "Can I see you in this weekend", envelopeImageUrlString: "https://example.com/image2.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2020/04/08/10/41/full-moon-5016871_1280.jpg", fromUserId: "user3", fromUserName: "MIMI", fromUserKabinettNumber: 789, toUserId: "user4", toUserName: "Yule", toUserKabinettNumber: 101, content: "Sample content 2", photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: true),
            Letter(id: UUID().uuidString, fontString: nil, postScript: "Can I see you in this weekend", envelopeImageUrlString: "https://example.com/image2.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2020/04/08/10/41/full-moon-5016871_1280.jpg", fromUserId: "user3", fromUserName: "MIMI", fromUserKabinettNumber: 789, toUserId: "user4", toUserName: "Yule", toUserKabinettNumber: 101, content: "Sample content 2", photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: true)
        ]
    }
    
    static var sampleSearchOfKeywordLetters: [Letter] {
        return [
            Letter(id: UUID().uuidString, fontString: nil, postScript: "토마토 좀 보내줄까? 올해 맛있다 🍅", envelopeImageUrlString: "https://example.com/image1.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2021/08/19/05/18/tomatoes-6557067_1280.jpg", fromUserId: "user1", fromUserName: "Yule", fromUserKabinettNumber: 123, toUserId: "user2", toUserName: "Rei", toUserKabinettNumber: 456, content: "Sample content 1", photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: false)
        ]
    }
    
    static var sampleSearchOfDateLetters: [Letter] {
        return [
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
    
    static var sampleLetterIsRead: [LetterType: Int] {
        return [
            .toMe: 1,
            .received: 2,
            .all: 3,
        ]
    }
    
    func getLetterBoxLetters(userId: String) async -> Result<[LetterType: [Letter]], any Error> {
        return .success(LetterBoxUseCaseStub.sampleLetterDictionary)
    }
    
    func getLetterBoxDetailLetters(userId: String, letterType: LetterType) async -> Result<[Letter], any Error> {
        return .success(LetterBoxUseCaseStub.sampleLetters)
    }
    
    func getIsRead(userId: String) async -> Result<[LetterType : Int], any Error> {
        return .success(LetterBoxUseCaseStub.sampleLetterIsRead)
    }
    
    func searchBy(userId: String, findKeyword: String, letterType: LetterType) async -> Result<[Letter]?, any Error> {
        return .success(LetterBoxUseCaseStub.sampleSearchOfKeywordLetters)
    }
    
    func searchBy(userId: String, letterType: LetterType, startDate: Date, endDate: Date) async -> Result<[Letter]?, any Error> {
        return .success(LetterBoxUseCaseStub.sampleSearchOfDateLetters)
    }
    
    func removeLetter(userId: String, letterId: String, letterType: LetterType) async -> Result<Bool, any Error> {
        return .success(true)
    }
    
    func updateIsRead(userId: String, letterId: String, letterType: LetterType) async -> Result<Bool, any Error> {
        return .success(true)
    }
}
