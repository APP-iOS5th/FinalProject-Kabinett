//
//  LoginView.swift
//  Kabinett
//
//  Created by Yule on 8/12/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var viewModel = SignUpViewModel(signUpUseCase: SignUpUseCaseStub())
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
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
                            if viewModel.loginError != nil {
                                showAlert = true
                            }
                        }
                        .padding(.horizontal, geometry.size.width * 0.06)
                        .frame(height: 54)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.background)
                }
                .navigationDestination(isPresented: $viewModel.loginSuccess) {
                    SignUpNameInputView(viewModel: viewModel)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("오류"),
                          message: Text(viewModel.loginError ?? "알 수 없는 로그인 오류가 발생했습니다."),
                          dismissButton: .default(Text("확인"))
                    )
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
