//
//  ProfileView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel = ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub())
    @State private var showSettingsView = false
    @State private var shouldNavigateToLogin = false
    @State private var shouldNavigateToProfileView = false
    
    var body: some View {
        NavigationStack {
            if profileViewModel.shouldNavigateToLogin || profileViewModel.isLoggedOut || profileViewModel.isDeletedAccount {
                LoginView()
            } else {
                GeometryReader { geometry in
                    VStack {
                        if let image = profileViewModel.profileImage {
                            Image(uiImage: image)
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
                        
                        Text(profileViewModel.userName)
                            .fontWeight(.regular)
                            .font(.system(size: 36))
                            .padding(.bottom, 0.1)
                        Text(profileViewModel.formattedKabinettNumber)
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
                            profileViewModel: profileViewModel,
                            shouldNavigateToProfileView: $shouldNavigateToProfileView,
                            onAccountActionComplete: handleAccountActionComplete
                        )
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
        .task {
            await checkUserStatus()
        }
        .onChange(of: shouldNavigateToProfileView) { _, newValue in
            if newValue {
                shouldNavigateToProfileView = false
            }
        }
    }
    
    func handleAccountActionComplete() {
        showSettingsView = false
        Task {
            await checkUserStatus()
        }
    }
    
    func checkUserStatus() async {
        await profileViewModel.checkUserStatus()
        shouldNavigateToLogin = profileViewModel.shouldNavigateToLogin
    }
}

#Preview {
    ProfileView(profileViewModel: ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub()))
}
