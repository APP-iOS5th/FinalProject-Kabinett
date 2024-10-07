//
//  SignUpUseCase.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/18/24.
//

import Foundation
import AuthenticationServices

enum SignUpResult {
    case newUser
    case registered
    case signInOnly
}

protocol SignUpUseCase {
    func getAvailableKabinettNumbers() async -> [Int]
    func signUp(
        with authorization: ASAuthorization,
        nonce: String
    ) async -> SignUpResult
    func startLoginUser(
        with userName: String,
        kabinettNumber: Int
    ) async -> Bool
}

final class SignUpUseCaseStub: SignUpUseCase {
    func getAvailableKabinettNumbers() async -> [Int] {
        [1, 100000, 445544]
    }
    
    func signUp(with authorization: ASAuthorization, nonce: String) async ->
    SignUpResult {
        try? await Task.sleep(for: .seconds(1)) // 프로그레스뷰 테스트
        //        .newUser
            return .registered
        //        .signInOnly
    }
    
    func startLoginUser(with userName: String, kabinettNumber: Int) async -> Bool {
        return true
    }
}
