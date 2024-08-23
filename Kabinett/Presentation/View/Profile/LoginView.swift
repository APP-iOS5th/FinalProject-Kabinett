//
//  LoginView.swift
//  Kabinett
//
//  Created by Yule on 8/12/24.
//

import SwiftUI
import AuthenticationServices
import CryptoKit

struct LoginView: View {
    @State private var currentNonce: String?
    
    var body: some View {
        GeometryReader { geometry in
            TabView{
                VStack{
                    Circle()
                        .foregroundColor(.primary300)
                        .frame(width: 110)
                        .padding(.bottom, -1)
                    Text("User")
                        .fontWeight(.regular)
                        .font(.system(size: 36))
                        .padding(.bottom, 0.1)
                    Text("000-000")
                        .fontWeight(.light)
                        .font(.system(size: 16))
                        .monospaced()
                        .padding(.bottom, 3)
                    Text("비회원 계정이에요.")
                        .fontWeight(.black)
                        .font(.system(size: 16))
                        .foregroundStyle(.contentSecondary)
                        .padding(.bottom, 25)
                    
                    SignInWithAppleButton { request in
                        handleSignInWithAppleRequest(request)
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                    let userIdentifier = appleIDCredential.user
                                    let userEmail = appleIDCredential.email ?? "이메일 정보 없음"
                                    print("사용자 ID: \(userIdentifier)")
                                    print("이메일: \(userEmail)")
                                } else {
                                    print("Apple ID credential 변환에 실패했습니다.")
                                }
                        case .failure(let error):
                            print("Authorization failed: \(error.localizedDescription)")
                        }
                    }
                    .padding(.horizontal, geometry.size.width * 0.06)
                    .frame(height: 54)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
            }
        }
    }
    
    private func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
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


#Preview {
    LoginView()
}
