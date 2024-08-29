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
            Letter(id: UUID().uuidString, fontString: nil, postScript: "토마토 좀 보내줄까? 올해 맛있다 🍅", envelopeImageUrlString: "https://example.com/image1.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2021/08/19/05/18/tomatoes-6557067_1280.jpg", fromUserId: "user1", fromUserName: "Yule", fromUserKabinettNumber: 123, toUserId: "user2", toUserName: "Rei", toUserKabinettNumber: 456, content: ["Sample content 1"], photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: false),
            Letter(id: UUID().uuidString, fontString: nil, postScript: "Can I see you in this weekend", envelopeImageUrlString: "https://example.com/image2.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2020/04/08/10/41/full-moon-5016871_1280.jpg", fromUserId: "user3", fromUserName: "MIMI", fromUserKabinettNumber: 789, toUserId: "user4", toUserName: "Yule", toUserKabinettNumber: 101, content: ["Sample content 2"], photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: true),
            Letter(id: UUID().uuidString, fontString: nil, postScript: "Can I see you in this weekend", envelopeImageUrlString: "https://example.com/image2.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2020/04/08/10/41/full-moon-5016871_1280.jpg", fromUserId: "user3", fromUserName: "MIMI", fromUserKabinettNumber: 789, toUserId: "user4", toUserName: "Yule", toUserKabinettNumber: 101, content: ["Sample content 2"], photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: true)
        ]
    }
    
    static var sampleSearchOfKeywordLetters: [Letter] {
        return [
            Letter(id: UUID().uuidString, fontString: nil, postScript: "레몬 좀 보내줄까? 올해 맛있다 🍋", envelopeImageUrlString: "https://example.com/image1.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2017/05/13/17/31/fruit-2310212_1280.jpg", fromUserId: "user1", fromUserName: "YUN", fromUserKabinettNumber: 123, toUserId: "user2", toUserName: "Min", toUserKabinettNumber: 456, content: ["Sample content 1"], photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: false)
        ]
    }
    
    static var sampleSearchOfDateLetters: [Letter] {
        return [
            Letter(id: UUID().uuidString, fontString: nil, postScript: "포도 좀 보내줄까? 올해 맛있다 🍇", envelopeImageUrlString: "https://example.com/image2.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2020/08/14/16/48/woman-5488508_1280.jpg", fromUserId: "user3", fromUserName: "WON", fromUserKabinettNumber: 789, toUserId: "user4", toUserName: "YUN", toUserKabinettNumber: 101, content: ["인공적으로 뿌린 축축한 풀 냄새가 아니라 잎사귀가 내뿜는 습한 안개 속에 둘러싸여 있는 그 애를 떠올리면 사랑스러움과 동시에 알 수 없는 불안이 솟고는 했다. 먼 곳을 내다보는 눈은 언제나 사람을 불안하게 만들지. 내가 가장 좋아했던 그 애의 크고 짙은 눈동자는, 그런 의미로 나를 가장 괴롭게 하는 부분이기도 했다. 그래서 나는 그 애가 돔에 가는 걸 원치 않았는데, 그토록 소망하던 무언가에 조금이라도 닿으면 그다음 걸음을 내디디고 싶어할 것 같았고, 반드시 해내고야 말 것 같았다.", "Sample content 2", "Sample content 3"], photoContents: ["https://cdn.pixabay.com/photo/2020/08/14/16/48/woman-5488508_1280.jpg", "https://cdn.pixabay.com/photo/2017/05/13/17/31/fruit-2310212_1280.jpg"], date: Date(), stationeryImageUrlString: nil, isRead: true),
            Letter(id: UUID().uuidString, fontString: nil, postScript: "레몬 좀 보내줄까? 올해 맛있다 🍋", envelopeImageUrlString: "https://example.com/image1.png", stampImageUrlString: "https://cdn.pixabay.com/photo/2017/05/13/17/31/fruit-2310212_1280.jpg", fromUserId: "user1", fromUserName: "YUN", fromUserKabinettNumber: 123, toUserId: "user2", toUserName: "Min", toUserKabinettNumber: 456, content: ["Sample content 1"], photoContents: [], date: Date(), stationeryImageUrlString: nil, isRead: false)
        ]
    }
    
    static var sampleLetterDictionary: [LetterType: [Letter]] {
        return [
            .sent: sampleSearchOfKeywordLetters, // 1개 예제
            .received: sampleSearchOfDateLetters, // 2개 예제
            .toMe: sampleSearchOfKeywordLetters,
            .all: sampleLetters // 3개 예제
        ]
    }
    
    static var sampleLetterIsRead: [LetterType: Int] {
        return [
            .toMe: 1,
            .received: 2,
            .all: 3,
        ]
    }
    
    func getLetterBoxLetters() async -> Result<[LetterType: [Letter]], any Error> {
        return .success(LetterBoxUseCaseStub.sampleLetterDictionary)
    }
    
    func getLetterBoxDetailLetters(letterType: LetterType) async -> Result<[Letter], any Error> {
        return .success(LetterBoxUseCaseStub.sampleLetterDictionary[letterType]!)
    }
    
    func getIsRead() async -> Result<[LetterType : Int], any Error> {
        return .success(LetterBoxUseCaseStub.sampleLetterIsRead)
    }
    
    func searchBy(findKeyword: String, letterType: LetterType) async -> Result<[Letter]?, any Error> {
        return .success(LetterBoxUseCaseStub.sampleSearchOfKeywordLetters)
    }
    
    func searchBy(letterType: LetterType, startDate: Date, endDate: Date) async -> Result<[Letter]?, any Error> {
        return .success(LetterBoxUseCaseStub.sampleSearchOfDateLetters)
    }
    
    func removeLetter(letterId: String, letterType: LetterType) async -> Result<Bool, any Error> {
        return .success(true)
    }
    
    func updateIsRead(letterId: String, letterType: LetterType) async -> Result<Bool, any Error> {
        return .success(true)
    }
}
