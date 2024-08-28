//
//  ProfileView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileSettingsViewModel
    var shouldHideBackButton: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack{
                    if let image = viewModel.profileImage {
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
                    
                    Text(viewModel.userName)
                        .fontWeight(.regular)
                        .font(.system(size: 36))
                        .padding(.bottom, 0.1)
                    Text(viewModel.formattedKabinettNumber)
                        .fontWeight(.light)
                        .font(.system(size: 16))
                        .monospaced()
                }
                .padding(.horizontal, geometry.size.width * 0.06)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .navigationBarBackButtonHidden(shouldHideBackButton)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView(viewModel: viewModel)) {
                            Image(systemName: "gearshape")
                                .fontWeight(.medium)
                                .font(.system(size: 19))
                                .foregroundColor(.contentPrimary)
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    ProfileView(viewModel: ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub()))
}
