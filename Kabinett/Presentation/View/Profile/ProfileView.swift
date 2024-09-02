//
//  ProfileView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var profileViewModel: ProfileSettingsViewModel
    @State private var showSettingsView = false
    @State private var shouldNavigateToProfileView = false
    
    var body: some View {
        NavigationStack {
            if case .toLogin = profileViewModel.navigateState {
                LoginView()
            } else {
                GeometryReader { geometry in
                    VStack {
                        if let image = profileViewModel.currentWriter.imageUrlString {
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
                        
                        Text(profileViewModel.currentWriter.name)
                            .fontWeight(.regular)
                            .font(.system(size: 36))
                            .padding(.bottom, 0.1)
                        Text(profileViewModel.currentWriter.formattedNumber)
                            .fontWeight(.light)
                            .font(.system(size: 16))
                            .monospaced()
                    }
                    .padding(.horizontal, geometry.size.width * 0.06)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.background)
                    .alert(
                        "오류",
                        isPresented: $profileViewModel.showProfileAlert
                    ) {
                        Button("확인", role: .cancel) {
                        }
                    } message: {
                        Text(profileViewModel.profileUpdateError ?? "알 수 없는 프로필 업데이트 오류가 발생했어요.")
                    }
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
                .navigationBarBackButtonHidden()
                
            }
        }
        .task {
            await profileViewModel.checkUserStatus()
            await profileViewModel.loadInitialData()
        }
    }
    
    func handleAccountActionComplete() {
        showSettingsView = false
    }
}

//#Preview {
//    ProfileView(profileViewModel: ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub()))
//}
