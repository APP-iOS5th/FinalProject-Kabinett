//
//  SettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ProfileSettingsViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var shouldNavigateToProfileView: Bool
    var onAccountActionComplete: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: ProfileSettingsView(
                        shouldNavigateToProfileView: $shouldNavigateToProfileView,
                        onComplete: {
                            shouldNavigateToProfileView = true
                            dismiss()
                        }
                    )) {
                        HStack{
                            Text("프로필 설정")
                                .fontWeight(.medium)
                                .font(.system(size: 17))
                                .foregroundColor(.contentPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 19))
                                .foregroundColor(.contentPrimary)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        .padding(.horizontal, geometry.size.width * 0.06)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    NavigationLink(destination: AccountSettingsView(onComplete: {
                        onAccountActionComplete()
                    })) {
                        HStack{
                            Text("계정 설정")
                                .fontWeight(.medium)
                                .font(.system(size: 17))
                                .foregroundColor(.contentPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 19))
                                .foregroundColor(.contentPrimary)
                        }
                        .padding(.horizontal, geometry.size.width * 0.06)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // TODO: - 추후에 다른 소셜로그인 추가되면 이미지 변경 가능하게 수정하기
                    HStack{
                        ZStack {
                            Rectangle()
                                .frame(width: 23, height: 23)
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            Image(systemName: "apple.logo")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 10)
                        Text(viewModel.appleID)
                            .font(.system(size: 17))
                            .foregroundColor(.contentSecondary)
                    }
                    .padding(.horizontal, geometry.size.width * 0.06)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .navigationTitle("설정")
                .navigationBarTitleDisplayMode(.inline)
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
        }
    }
}
    
    //#Preview {
    //    SettingsView(profileViewModel: ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub()))
    //}
