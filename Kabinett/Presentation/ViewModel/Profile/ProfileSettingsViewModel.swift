//
//  ProfileSettingsViewModel.swift
//  Kabinett
//
//  Created by Yule on 8/15/24.
//

import SwiftUI
import Combine
import PhotosUI

class ProfileSettingsViewModel: ObservableObject {
    private let profileUseCase: ProfileUseCase
    
    @Published var userName: String = ""
    @Published var newUserName: String = ""
    @Published var formattedKabinettNumber: String = ""
    @Published var appleID: String = ""
    @Published var profileImage: UIImage?
    @Published var isShowingImagePicker = false
    @Published var selectedImageItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var isShowingCropper = false
    @Published var croppedImage: UIImage?
    @Published var isProfileUpdated = false
    @Published var shouldNavigateToSettings = false
    
    init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
        
        Task {
            await loadInitialData()
            await fetchAppleID()
        }
    }
    
    private func loadInitialData() async {
        let writer = await profileUseCase.getCurrentWriter()
        DispatchQueue.main.async {
            self.userName = writer.name
            self.formattedKabinettNumber = formatKabinettNumber(writer.kabinettNumber)
            if let imageUrlString = writer.profileImage,
               let imageUrl = URL(string: imageUrlString),
               let imageData = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: imageData) {
                self.profileImage = image
            } else {
                self.profileImage = nil
            }
        }
    } // 프로필 이미지 없을 때 탭바 이미지도 설정하기
    
    private func fetchAppleID() async {
        let ID = await profileUseCase.getAppleID()
        self.appleID = ID
    }
    
    var isUserNameVaild: Bool {
        return !newUserName.isEmpty
    }
    
    var displayName: String {
        return newUserName.isEmpty ? userName : newUserName
    }
    
    func updateUserName() {
        if isUserNameVaild {
            userName = newUserName
        }
    }
    
    func updateProfileImage() {
        if let croppedImage = croppedImage {
            self.profileImage = croppedImage
            isProfileUpdated = true
            print("Profile image updated in ViewModel. New image size: \(croppedImage.size)")
        } else {
            print("No image to update")
        }
    }
    
    func selectProfileImage() {
        isShowingImagePicker = true
    }
    
    func handleImageSelection(newItem: PhotosPickerItem?) {
        Task {
            if let item = newItem,
               let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
                isShowingCropper = true
            }
        }
    }
    
    func completeProfileUpdate() {
        updateUserName()
        updateProfileImage()
        objectWillChange.send()
    }
    
    func crop(image: UIImage, cropArea: CGRect, imageViewSize: CGSize) {
        let scaleX = image.size.width / imageViewSize.width * image.scale
        let scaleY = image.size.height / imageViewSize.height * image.scale
        let scaledCropArea = CGRect(
            x: cropArea.origin.x * scaleX,
            y: cropArea.origin.y * scaleY,
            width: cropArea.size.width * scaleX,
            height: cropArea.size.height * scaleY
        )
        
        guard let cutImageRef: CGImage =
                image.cgImage?.cropping(to: scaledCropArea) else {
            return
        }
        
        let croppedImage = UIImage(cgImage: cutImageRef)
        DispatchQueue.main.async {
            self.croppedImage = croppedImage
            self.isShowingCropper = false
        }
    }
}
