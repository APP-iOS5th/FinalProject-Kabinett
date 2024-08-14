//
//  SettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: ProfileSettingsView()) {
                        HStack{
                            Text("프로필 설정")
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 19))
                                .foregroundColor(.contentPrimary)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .padding(.horizontal, geometry.size.width * 0.06)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: AccountSettingsView()) {
                        HStack{
                            Text("계정 설정")
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 19))
                                .foregroundColor(.contentPrimary)
                        }
                        .padding(.horizontal, geometry.size.width * 0.06)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack{
                        ZStack {
                            Rectangle()
                                .frame(width: 25, height: 25)
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            Image(systemName: "apple.logo")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 10)
                        Text("figfigure33@gmail.com")
                            .fontWeight(.medium)
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, geometry.size.width * 0.06)
                    
                    NavigationLink(destination: OpenSourceLicensesView()) {
                        HStack{
                            Text("오픈소스 라이선스")
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 19))
                                .foregroundColor(.contentPrimary)
                        }
                    }
                    .padding(.horizontal, geometry.size.width * 0.06)
                    Spacer()
                }
                .buttonStyle(PlainButtonStyle())
                    
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            
                        }) {
                            Text("완료")
                                .fontWeight(.medium)
                                .font(.system(size: 18))
                                .foregroundColor(.contentPrimary)
                                .padding(.trailing, 8)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
