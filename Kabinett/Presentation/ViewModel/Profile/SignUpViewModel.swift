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

final class SignUpViewModel: ObservableObject {
    private let useCase: any SignupUseCase
    
    @Published var userName: String = ""
    @Published var availablekabinettNumbers: [String] = [] //서버에서 받는 번호들
    @Published var selectedKabinettNumber: Int? = nil
    @Published var currentNonce: String?
    @Published var userIdentifier: String?
    @Published var userEmail: String?
    @Published var loginError: String?
    @Published var loginSuccess: Bool = false
    
    init(useCase: any SignupUseCase) {
        self.useCase = useCase
    }
    
    @MainActor
    func getNumbers() async {
        let numbers = await useCase.getAvailableKabinettNumbers()
        availablekabinettNumbers = numbers
            .map {
                formatNumber($0)
            }
    }
    private func formatNumber(_ number: Int) -> String {
        let formattedNumber = String(format: "%06d", number)
        let startIndex = formattedNumber.index(formattedNumber.startIndex, offsetBy: 3)
        let part1 = formattedNumber[..<startIndex]
        let part2 = formattedNumber[startIndex...]
        
        return "\(part1)-\(part2)"
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    @MainActor
    func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            Task {
                let sucess = await useCase.signUp(authorization)
                await MainActor.run {
                    if sucess {
                        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                            let userIdentifier = appleIDCredential.user
                            let userEmail = appleIDCredential.email ?? "이메일 정보 없음"
                            self.loginSuccess = true
                            self.loginError = nil
                            print("사용자 ID: \(userIdentifier)")
                            print("이메일: \(userEmail)")
                            print("로그인 성공")
                        }
                    } else {
                        self.loginError = "로그인에 실패했습니다."
                        print("로그인 실패")
                    }
                }
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
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
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

