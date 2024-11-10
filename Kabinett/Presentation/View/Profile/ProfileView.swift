//
//  ProfileView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI
import Kingfisher

// `ProfileView`
struct ProfileView: View {
    //
    @StateObject private var viewModel: ProfileViewModel
    
    init() {
        @Injected(ProfileUseCaseKey.self)
        var profileUseCase: ProfileUseCase
        
        self._viewModel = StateObject(
            wrappedValue: ProfileViewModel(profileUseCase: profileUseCase)
        )
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if case .toLogin = viewModel.navigateState {
                    SignUpView()
                } else {
                    ZStack {
                        Color.background.ignoresSafeArea(.all)
                        if viewModel.profileUpdateError != nil {
//                            VStack {
//                                Text("프로필을 불러오는 데 문제가 발생했어요.")
//                                    .fontWeight(.regular)
//                                    .foregroundColor(.alert)
//                                    .font(.headline)
//                                    .padding()
//                            }
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
                    .alert(
                        "오류",
                        isPresented: $viewModel.showProfileAlert
                    ) {
                        Button("확인", role: .cancel) {
                        }
                    } message: {
                        Text(viewModel.profileUpdateError ?? "프로필을 불러오는 데 문제가 발생했어요.")
                    }
                    .navigationBarBackButtonHidden()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewModel.showSettingsView = true
                            } label: {
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
                SettingsView(viewModel: viewModel)
            }
        }
    }
}
