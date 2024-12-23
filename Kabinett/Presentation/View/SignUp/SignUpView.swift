//
//  SignUpView.swift
//  Kabinett
//
//  Created by Yule on 8/12/24.
//

import FirebaseAnalytics
import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    @StateObject private var viewModel: SignUpViewModel
    let horizontalPadding: CGFloat = UIScreen.main.bounds.width * 0.06
    
    init() {
        @Injected(SignUpUseCaseKey.self)
        var signUpUseCase: SignUpUseCase
        
        self._viewModel = StateObject(
            wrappedValue: SignUpViewModel(signUpUseCase: signUpUseCase))
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            
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
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            
            VStack {
                SignInWithAppleButton { request in
                    viewModel.handleSignInWithAppleRequest(request)
                } onCompletion: { result in
                    viewModel.handleAuthorization(result: result)
                }
                .frame(height: 54)
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 330)
                
            }
        }
        .overlay(
            viewModel.isLoading ? LoadingView() : nil
        )
        .navigationDestination(isPresented: $viewModel.showSignUpFlow) {
            SignUpNameInputView(viewModel: viewModel)
        }
        .alert(
            "오류",
            isPresented: $viewModel.showAlert
        ) {
            Button("확인", role: .cancel) {
            }
        } message: {
            Text(viewModel.loginError ?? "로그인 오류가 발생했어요. 카비넷 팀에게 알려주세요.")
        }
        .analyticsScreen(
            name: "\(type(of:self))",
            extraParameters: [
                AnalyticsParameterScreenName: "\(type(of:self))",
                AnalyticsParameterScreenClass: "\(type(of:self))",
            ]
        )
    }
}
