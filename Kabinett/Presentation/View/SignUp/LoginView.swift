//
//  LoginView.swift
//  Kabinett
//
//  Created by Yule on 8/12/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject private var viewModel: SignUpViewModel
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
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
                        viewModel.handleAuthorization(result: result)
                    }
                    .padding(.horizontal, geometry.size.width * 0.06)
                    .frame(height: 54)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
            }
            .navigationDestination(isPresented: $viewModel.showSignUpFlow) {
                SignUpNameInputView()
            }
            .alert(
                "오류",
                isPresented: $viewModel.showAlert
            ) {
                Button("확인", role: .cancel) {
                }
            } message: {
                Text(viewModel.loginError ?? "알 수 없는 로그인 오류가 발생했어요.")
            }
        }
    }
}

#Preview {
    LoginView()
}
