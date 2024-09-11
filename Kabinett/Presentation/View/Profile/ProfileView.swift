//
//  ProfileView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            if case .toLogin = viewModel.navigateState {
                LoginView()
            } else {
                ZStack {
                    Color.background.ignoresSafeArea(.all)
                    if viewModel.profileUpdateError != nil {
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
                    } else {
                        VStack {
                            if let image = viewModel.currentWriter.imageUrlString {
                                KFImage(URL(string: image))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:110, height: 110)
                                    .clipShape(Circle())
                                    .padding(.bottom, -1)
                            } else {
                                Circle()
                                    .foregroundColor(.primary300)
                                    .frame(width: 110, height: 110)
                                    .padding(.bottom, -1)
                            }
                            
                            Text(viewModel.currentWriter.name)
                                .fontWeight(.regular)
                                .font(.system(size: 36))
                                .padding(.bottom, 0.1)
                            Text(viewModel.currentWriter.formattedNumber)
                                .fontWeight(.light)
                                .font(.system(size: 16))
                                .monospaced()
                        }
                    }
                }
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.showSettingsView = true
                        }) {
                            Image(systemName: "gearshape")
                                .fontWeight(.medium)
                                .font(.system(size: 19))
                                .foregroundColor(.contentPrimary)
                        }
                        .padding(.trailing, UIScreen.main.bounds.width * 0.0186) // 툴바아이템에 패딩 16이 먹여져있는 것 같다.
                    }
                }
                
            }
        }
        .navigationDestination(isPresented: $viewModel.showSettingsView) {
            SettingsView()
        }
    }
}
