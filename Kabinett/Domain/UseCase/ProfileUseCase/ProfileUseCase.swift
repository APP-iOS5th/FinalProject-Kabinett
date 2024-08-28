//
//  ProfileUseCase.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/16/24.
//

import Foundation
import Combine

protocol ProfileUseCase {
    func isAnonymous() async -> AnyPublisher<Bool, Never>
    func getCurrentWriter() async -> Writer
    func getAppleID() async -> String
    func updateWriter(
        newWriterName: String,
        profileImage: Data?
    ) async -> Bool
    func signout() async -> Bool
    func deleteId() async -> Bool
}

final class ProfileUseCaseStub: ProfileUseCase {
    func isAnonymous() async -> AnyPublisher<Bool, Never> {
        Just(false)
            .eraseToAnyPublisher()
    }
    func getCurrentWriter() async -> Writer {
        return Writer(
            name: "Yule",
            kabinettNumber: 455444,
            profileImage: nil)
    }

    func getAppleID() async -> String {
        "figfigure13@gmail.com"
    }
    
    func updateWriter(newWriterName: String, profileImage: Data?) async -> Bool {
        true
    }
    func signout() async -> Bool {
        false
    }
    func deleteId() async -> Bool {
        false
    }
}
