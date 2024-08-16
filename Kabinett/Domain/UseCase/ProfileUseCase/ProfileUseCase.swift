//
//  ProfileUseCase.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/16/24.
//

import Foundation
import AuthenticationServices

protocol ProfileUseCase {
    func isAnonymous() async -> Bool
    func getAvailableKabinettNumbers() async -> [Int]
    func getCurrentWriter() async -> Writer
    func signUp(
        with userName: String,
        kabinettNumber: Int,
        _ authorization: ASAuthorization
    ) async -> Bool
    func updateWriter(
        newWriterName: String,
        profileImage: Data?
    ) async -> Bool
}
