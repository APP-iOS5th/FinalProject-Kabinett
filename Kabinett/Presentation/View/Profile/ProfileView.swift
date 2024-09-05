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
    @State private var showSettingsView = false
    @State private var shouldNavigateToProfileView = false
    
    var body: some View {
        NavigationStack {
            if case .toLogin = viewModel.navigateState {
                LoginView()
            } else {
                GeometryReader { geometry in
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.background)
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
                        .padding(.horizontal, geometry.size.width * 0.06)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.background)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    showSettingsView = true
                                }) {
                                    Image(systemName: "gearshape")
                                        .fontWeight(.medium)
                                        .font(.system(size: 19))
                                        .foregroundColor(.contentPrimary)
                                }
                            }
                        }
                        .sheet(isPresented: $showSettingsView) {
                            SettingsView(
                                shouldNavigateToProfileView: $shouldNavigateToProfileView,
                                onAccountActionComplete: handleAccountActionComplete
                            )
                        }
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
    }
    
    func handleAccountActionComplete() {
        showSettingsView = false
    }
}

//#Preview {
//    ProfileView(profileViewModel: ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub()))
//}
