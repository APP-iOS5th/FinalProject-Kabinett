//
//  AccountSettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct AccountSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Button(action: {
                        print("로그아웃")
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
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contentShape(Rectangle())
                    
                    Spacer()
                    
                    Button(action: {
                        print("회원탈퇴")
                    }) {
                        VStack {
                            Text("회원 탈퇴하기")
                                .foregroundColor(.alert)
                                .padding(.bottom, 5)
                            Text("저장된 데이터가 모두 사라집니다.")
                                .font(.system(size: 12))
                                .foregroundColor(.contentSecondary)
                        }
                        .padding(.horizontal, geometry.size.width * 0.06)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contentShape(Rectangle())
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
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

#Preview {
    AccountSettingsView()
}
