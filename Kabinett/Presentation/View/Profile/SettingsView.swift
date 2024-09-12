//
//  SettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    let horizontalPadding: CGFloat = UIScreen.main.bounds.width * 0.06
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                NavigationLink(destination: ProfileSettingsView()) {
                    HStack{
                        Text("프로필 설정")
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
                    .padding(.bottom, 25)
                    .padding(.horizontal, horizontalPadding)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: AccountSettingsView()) {
                    HStack{
                        Text("계정 설정")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                            .foregroundColor(.contentPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundColor(.contentPrimary)
                    }
                    .padding(.horizontal, horizontalPadding)
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
                .padding(.horizontal, horizontalPadding)
                
                Spacer()
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
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
    }
    
}
