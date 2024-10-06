//
//  SignUpViewModel.swift
//  Kabinett
//
//  Created by Yule on 8/16/24.
//

import SwiftUI
import Combine
import AuthenticationServices
import CryptoKit
import os

final class SignUpViewModel: ObservableObject {
    private let signUpUseCase: any SignUpUseCase
    
    private let logger = Logger(
        subsystem: "co.kr.codegrove.Kabinett",
        category: "SignUpViewModel"
    )
    
    @Published var userName: String = ""
    @Published private(set) var availablekabinettNumbers: [String] = [] //서버에서 받는 번호들
    @Published var selectedKabinettNumber: Int? = nil
    @Published private(set) var loginError: String?
    @Published var signUpError: String?
    @Published var showAlert: Bool = false
    @Published var showSignUpFlow: Bool = false
    @Published var isLoading: Bool = false
    
    private var nonce: String = ""
    
    init(signUpUseCase: any SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
    }
    
    @MainActor
    func startLoginUser(with userName: String, kabinettNumber: String) async -> Bool {
        guard let kabinettNumberInt = Int(kabinettNumber.replacingOccurrences(of: "-", with: "")) else {
            return false
        }
        
        return await signUpUseCase.startLoginUser(with: userName, kabinettNumber: kabinettNumberInt)
    }
    
    @MainActor
    func getNumbers() async {
        isLoading = true
        let numbers = await signUpUseCase.getAvailableKabinettNumbers()
        await MainActor.run {
            availablekabinettNumbers = numbers.map { $0.formatKabinettNumber() }
            isLoading = false
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email]
        nonce = randomNonceString()
        request.nonce = sha256(nonce)
    }

    func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            startLoading()
            Task { @MainActor in
                let result = await signUpUseCase.signUp(with: authorization, nonce: nonce)
                switch result {
                case .newUser, .signInOnly:
                    showSignUpFlow = true
                case .registered:
                    showSignUpFlow = false
                }
                stopLoading()
            }
        case let .failure(error):
            logger.error("Apple Sign in error: \(error.localizedDescription)")
            self.loginError = "애플 로그인에 실패했어요."
            self.showAlert = true
        }
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode).")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func startLoading() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

