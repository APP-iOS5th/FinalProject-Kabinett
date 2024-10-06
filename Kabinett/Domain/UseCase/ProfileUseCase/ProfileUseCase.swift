//
//  ProfileUseCase.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/16/24.
//

import Foundation
import Combine

enum UserStatus {
    case anonymous
    case registered
    case incomplete
}

protocol ProfileUseCase {
    func getCurrentUserStatus() -> AnyPublisher<UserStatus, Never>
    func getCurrentWriter() -> AnyPublisher<Writer, Never>
    func getAppleID() async -> String
    func updateWriter(
        newWriterName: String,
        profileImage: Data?
    ) async -> Bool
    func signout() async -> Bool
    func deleteId() async -> Bool
}

final class ProfileUseCaseStub: ProfileUseCase {
    func getCurrentUserStatus() -> AnyPublisher<UserStatus, Never> {
//        Just(.anonymous)
//        Just(.incomplete)
        Just(.registered)
            .eraseToAnyPublisher()
    }
    func getCurrentWriter() -> AnyPublisher<Writer, Never> {
        Just(.anonymousWriter)
            .eraseToAnyPublisher()
    }

    func getAppleID() async -> String {
        "figfigure13@gmail.com"
    }
    
    func updateWriter(newWriterName: String, profileImage: Data?) async -> Bool {
//        true
        false
    }
    
    func signout() async -> Bool {
        try? await Task.sleep(for: .seconds(1)) // 프로그레스뷰 테스트
        return true
    }
    
    func deleteId() async -> Bool {
        true
    }
}
