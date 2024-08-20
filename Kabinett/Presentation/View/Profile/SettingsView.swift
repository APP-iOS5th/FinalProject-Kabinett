//
//  SettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ProfileSettingsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: ProfileSettingsView(viewModel: viewModel)) {
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
                        .padding(.bottom, 20)
                        .padding(.horizontal, geometry.size.width * 0.06)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: AccountSettingsView()) {
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
                        Text(viewModel.appleID)
                            .font(.system(size: 17))
                            .foregroundColor(.contentPrimary)
                    }
                    .padding(.horizontal, geometry.size.width * 0.06)

                    Spacer()
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .navigationTitle("설정")
                .navigationBarTitleDisplayMode(.inline)
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
    SettingsView(viewModel: ProfileSettingsViewModel())
}
