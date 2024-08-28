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

final class SignUpUseCaseStub: SignupUseCase {
    func getAvailableKabinettNumbers() async -> [Int] {
        [1, 100000, 445544]
    }
    
    func signUp(_ authorization: ASAuthorization) async -> Bool {
        true
    }
    
    func startLoginUser(with userName: String, kabinettNumber: Int) async -> Bool {
        print("Received userName in UseCase: \(userName)")
        print("Received Kabinett Number in UseCase: \(kabinettNumber)")
        return true
    }
}
