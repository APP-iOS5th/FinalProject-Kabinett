//
//  SignUpUseCase.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/18/24.
//

import Foundation
import AuthenticationServices

protocol SignupUseCase {
    func getAvailableKabinettNumbers() async -> [Int]
    func signUp(
        _ authorization: ASAuthorization
    ) async -> Bool
    func startLoginUser(
        with userName: String,
        kabinettNumber: Int
    ) async -> Bool
}