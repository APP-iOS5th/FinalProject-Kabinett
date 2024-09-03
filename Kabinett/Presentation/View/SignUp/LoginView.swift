//
//  LoginView.swift
//  Kabinett
//
//  Created by Yule on 8/12/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject private var signUpViewModel: SignUpViewModel
    @Environment(\.dismiss) var dismiss
    
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
                            signUpViewModel.handleSignInWithAppleRequest(request)
                        } onCompletion: { result in
                            signUpViewModel.handleAuthorization(result: result)
                        }
                        .padding(.horizontal, geometry.size.width * 0.06)
                        .frame(height: 54)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.background)
                }
                .navigationDestination(isPresented: $signUpViewModel.loginSuccess) {
                    SignUpNameInputView()
                }
                .navigationDestination(isPresented: $signUpViewModel.signUpSuccess) {
                    if signUpViewModel.signUpSuccess {
                        ProfileView()
                    } else {
                        VStack {
                            Text("프로필을 불러오는 데 문제가 발생했어요.")
                                .fontWeight(.regular)
                                .foregroundColor(.alert)
                                .font(.headline)
                                .padding()
                            
                            NavigationLink(destination: SignUpNameInputView()) {
                                Text("다시 시도하기")
                                    .padding()
                                    .background(Color.primary900)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.background)
                    }
                }
                .alert(
                    "오류",
                    isPresented: $signUpViewModel.showAlert
                ) {
                    Button("확인", role: .cancel) {
                    }
                } message: {
                    Text(signUpViewModel.loginError ?? "알 수 없는 로그인 오류가 발생했어요.")
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    LoginView()
}
