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
    @StateObject private var viewModel = SignUpViewModel(useCase: SignUpUseCaseStub())
    
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
                        viewModel.handleSignInWithAppleRequest(request)
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
}
    

#Preview {
    LoginView()
}
