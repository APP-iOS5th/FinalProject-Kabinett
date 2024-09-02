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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userName: String = ""
    @Published var newUserName: String = ""
    @Published var appleID: String = ""
    @Published var isShowingImagePicker = false
    @Published var selectedImageItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var isShowingCropper = false
    @Published var croppedImage: UIImage?
    @Published var isProfileUpdated = false
    @Published var userStatus: UserStatus?
    @Published var profileUpdateError: String?
    @Published var showProfileAlert = false
    
    init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
        
        Task {
            await loadInitialData()
            await checkUserStatus()
            await fetchAppleID()
        }
    }
    // TODO: 프로필 이미지 없을 때 탭바 이미지도 설정하기
    @MainActor
    private func loadInitialData() async {
        let writer = await profileUseCase.getCurrentWriter()
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
    
    @MainActor
    func checkUserStatus() async {
        await profileUseCase.getCurrentUserStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.userStatus = status
                switch status {
                case .anonymous:
                    self?.shouldNavigateToLogin = true
                case .incomplete:
                    self?.shouldNavigateToLogin = true
                case .registered:
                    self?.shouldNavigateToProfile = true
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
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
    
    @MainActor
    func completeProfileUpdate() async {
        updateUserName()
        updateProfileImage()
        objectWillChange.send()
        
        let success = await profileUseCase.updateWriter(
            newWriterName: userName,
            profileImage: croppedImage?.jpegData(compressionQuality: 0.8)
        )
        
        if success {
            isProfileUpdated = true
        } else {
            profileUpdateError = "프로필 업데이트에 실패했어요. 다시 시도해주세요."
            showProfileAlert = true
        }
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
                await MainActor.run {
                    self.selectedImage = uiImage
                    self.isShowingCropper = true
                }
            }
        }
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
    
    @MainActor
    func signout() async {
        let success = await profileUseCase.signout()
        if success {
            isLoggedOut = true
        } else {
            print("로그아웃에 실패했어요.")
        }
    }
    
    @MainActor
    func deletieID() async {
        let success = await profileUseCase.deleteId()
        if success {
            isDeletedAccount = true
        } else {
            print("회원탈퇴에 실패했어요.")
        }
    }
}
