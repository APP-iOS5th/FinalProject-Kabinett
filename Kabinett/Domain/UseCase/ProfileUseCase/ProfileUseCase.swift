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
    func updateWriter(
        newWriterName: String,
        profileImage: Data?
    ) async -> Bool
    func signout() async -> Bool
    func deleteId() async -> Bool
}
