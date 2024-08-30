//
//  ProfileView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileViewModel = ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub())
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                Group {
                    if profileViewModel.shouldNavigateToLogin {
                        LoginView()
                    } else {
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
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: SettingsView(profileViewModel: profileViewModel)) {
                                    Image(systemName: "gearshape")
                                        .fontWeight(.medium)
                                        .font(.system(size: 19))
                                        .foregroundColor(.contentPrimary)
                                }
                            }
                        }
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
        .onAppear {
            Task {
                await profileViewModel.checkUserStatus()
                print("User status after check: \(profileViewModel.userStatus))")
                print("Should navigate to login: \(profileViewModel.shouldNavigateToLogin)")
            }
        }
    }
}

#Preview {
    ProfileView(profileViewModel: ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub()))
}
