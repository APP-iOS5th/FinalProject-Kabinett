//
//  AccountSettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct AccountSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showLogoutAlert = false
    @State private var showAccountDeletionAlert = false
    @ObservedObject var profileViewModel: ProfileSettingsViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack{
                            Text("로그아웃하기")
                                .fontWeight(.medium)
                                .font(.system(size: 17))
                                .foregroundColor(.contentPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 19))
                                .foregroundColor(.contentPrimary)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, geometry.size.width * 0.06)
                        .contentShape(Rectangle())
                    }
                    .alert(
                        "로그아웃하시겠어요?",
                        isPresented: $showLogoutAlert
                    ) {
                        Button("로그아웃", role: .destructive) {
                            Task {
                                await profileViewModel.signout()
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
                                    .foregroundColor(.alert)
                                    .padding(.bottom, 3)
                                Text("저장된 데이터가 모두 사라져요.")
                                    .font(.system(size: 12))
                                    .foregroundColor(.contentSecondary)
                                    .padding(.bottom, 20)
                            }
                            .padding(.horizontal, geometry.size.width * 0.06)
                            .contentShape(Rectangle())
                        }
                        .alert(
                            "회원 탈퇴하시겠어요?",
                            isPresented: $showAccountDeletionAlert
                        ) {
                            Button("회원탈퇴", role: .destructive) {
                                Task {
                                    await profileViewModel.deletieID()
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
                            }
                            .foregroundColor(.primary900)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .navigationTitle("계정 설정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    AccountSettingsView()
//}
