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
    case alreadyRegistered
    case appleSignInOnly
}

protocol SignupUseCase {
    func getAvailableKabinettNumbers() async -> [Int]
    func signUp(
        _ authorization: ASAuthorization
    ) async -> SignUpResult
    func startLoginUser(
        with userName: String,
        kabinettNumber: Int
    ) async -> Bool
}

final class SignUpUseCaseStub: SignupUseCase {
    func getAvailableKabinettNumbers() async -> [Int] {
        [1, 100000, 445544]
    }
    
    func signUp(_ authorization: ASAuthorization) async -> SignUpResult {
        .newUser
//        .alreadyRegistered
//        .appleSignInOnly
//        fatalError("테스트용 실패")
    }
    
    func startLoginUser(with userName: String, kabinettNumber: Int) async -> Bool {
        print("Received userName in UseCase: \(userName)")
        print("Received Kabinett Number in UseCase: \(kabinettNumber)")
        return true
    }
}
