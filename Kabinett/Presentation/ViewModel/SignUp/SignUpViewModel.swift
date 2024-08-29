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
    private let signUpUseCase: any SignupUseCase
    
    @Published var profileViewModel: ProfileSettingsViewModel?
    @Published var userName: String = ""
    @Published var availablekabinettNumbers: [String] = [] //서버에서 받는 번호들
    @Published var selectedKabinettNumber: Int? = nil
    @Published var currentNonce: String?
    @Published var userIdentifier: String?
    @Published var loginError: String?
    @Published var signUpError: String?
    @Published var loginSuccess: Bool = false
    @Published var signUpSuccess: Bool = false
    @Published var showAlert: Bool = false
    
    init(signUpUseCase: any SignupUseCase) {
        self.signUpUseCase = signUpUseCase
    }
    
    @MainActor
       func startLoginUser(with userName: String, kabinettNumber: String) async -> Bool {
           guard let kabinettNumberInt = Int(kabinettNumber.replacingOccurrences(of: "-", with: "")) else {
               print("Invalid Kabinett number format")
               return false
           }
           
           return await signUpUseCase.startLoginUser(with: userName, kabinettNumber: kabinettNumberInt)
       }
    
    @MainActor
    func getNumbers() async {
        let numbers = await signUpUseCase.getAvailableKabinettNumbers()
        availablekabinettNumbers = numbers
            .map {
                formatKabinettNumber($0)
            }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            Task { @MainActor in
                let signUpResult = await signUpUseCase.signUp(authorization)
                switch signUpResult {
                case .newUser:
                    print("Sign up State: New User")
                    self.loginSuccess = true
                case .alreadyRegistered:
                    self.profileViewModel = ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub()) //프로필 뷰 오류 테스트하려면 여기 주석처리
                    print("Sign up State: Already Registered")
                    self.signUpSuccess = true
                case .signInOnly:
                    print("Sign up State: Apple SignIn Only")
                    self.loginSuccess = true
                }
            }
        case .failure(let error):
            print("애플 로그인 실패: \(error.localizedDescription)")
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
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

