//
//  ProfileSettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI
import PhotosUI

struct ProfileSettingsView: View {
    @ObservedObject var viewModel: ProfileSettingsViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var shouldNavigateToProfileView: Bool
    
    var body: some View {
        NavigationStack {
            VStack{
                photoPickerView()
                userInfoInputFields()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .navigationTitle("프로필 설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.primary900)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.completeProfileUpdate()
                        shouldNavigateToProfileView = true
                        dismiss()
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
        .sheet(isPresented: $viewModel.isShowingCropper) {
            if let profileImage = viewModel.selectedImage {
                ImageCropper(viewModel: viewModel, isShowingCropper: $viewModel.isShowingCropper, image: profileImage)
            } else {
                Text("No image available for cropping.")
            }
        }
        .onDisappear {
            if shouldNavigateToProfileView {
                DispatchQueue.main.async {
                    shouldNavigateToProfileView = true
                }
            }
            if !viewModel.isProfileUpdated {
                viewModel.croppedImage = nil
            }
            viewModel.selectedImageItem = nil
        }
    }
    @ViewBuilder
    private func photoPickerView() -> some View {
        PhotosPicker(
            selection: $viewModel.selectedImageItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            ZStack {
                Circle()
                    .foregroundColor(.primary300)
                    .frame(width: 110, height: 110)
                if let image = viewModel.croppedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                }
                Image(systemName: "photo")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
        }
        .onChange(of: viewModel.selectedImageItem) { oldItem, newItem in
            viewModel.handleImageSelection(newItem: newItem)
        }
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    private func userInfoInputFields() -> some View {
        VStack {
            TextField(viewModel.displayName, text: $viewModel.newUserName)
                .textFieldStyle(ProfileOvalTextFieldStyle())
                .autocorrectionDisabled(true)
                .keyboardType(.alphabet)
                .submitLabel(.done)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
                .font(Font.system(size: 25, design: .default))
                .padding(.bottom, 10)
            
            Text(viewModel.formattedKabinettNumber)
                .fontWeight(.light)
                .font(.system(size: 16))
                .monospaced()
        }
    }
    
    struct ProfileOvalTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(10)
                .background(
                    Capsule()
                        .stroke(Color.primary300, lineWidth: 1)
                        .background(Capsule().fill(Color.white))
                )
                .frame(width: 270, height: 54)
        }
    }
}



//#Preview {
//    ProfileSettingsView(viewModel: ProfileSettingsViewModel(), shouldNavigateToProfileView: <#Binding<Bool>#>)
//}
