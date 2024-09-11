//
//  AccountSettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct AccountSettingsView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showLogoutAlert = false
    @State private var showAccountDeletionAlert = false
    
    let horizontalPadding: CGFloat = UIScreen.main.bounds.width * 0.06
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            VStack {
                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack{
                        Text("로그아웃하기")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                            .foregroundColor(.contentPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundColor(.contentPrimary)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                    .contentShape(Rectangle())
                }
                .alert(
                    "로그아웃하시겠어요?",
                    isPresented: $showLogoutAlert
                ) {
                    Button("로그아웃", role: .destructive) {
                        Task {
                            await viewModel.signout()
                            viewModel.showSettingsView = false
                        }
                    }
                    Button("취소", role: .cancel) {}
                }
                
                Spacer()
                
                Button(action: {
                    showAccountDeletionAlert = true
                }) {
                    VStack {
                        Text("회원 탈퇴하기")
                            .font(.system(size: 18))
                            .foregroundColor(.alert)
                            .padding(.bottom, 2)
                        Text("저장된 데이터가 모두 사라져요.")
                            .font(.system(size: 14))
                            .foregroundColor(.contentSecondary)
                            .padding(.bottom, 20)
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                    .contentShape(Rectangle())
                }
                .alert(
                    "회원 탈퇴하시겠어요?",
                    isPresented: $showAccountDeletionAlert
                ) {
                    Button("회원탈퇴", role: .destructive) {
                        Task {
                            await viewModel.deletieID()
                            viewModel.showSettingsView = false
                        }
                    }
                    Button("취소", role: .cancel) {}
                } message: {
                    Text("저장된 데이터가 모두 사라져요.")
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.leading, 5)
                        }
                        .foregroundColor(.primary900)
                    }
                }
            }
        }
        .navigationTitle("계정 설정")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    AccountSettingsView()
//}
