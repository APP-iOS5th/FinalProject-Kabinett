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
    @Published var userName: String
    @Published var newUserName: String = ""
    @Published var profileImage: UIImage?
    @Published var kabinettNumber: String
    @Published var appleID: String
    @Published var shouldNavigateToSettings = false
    @Published var shouldNavigateToProfile = false
    @Published var selectedImageItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var isShowingImagePicker = false
    @Published var isShowingCropper = false
    @Published var croppedImage: UIImage?
    @Published var isProfileUpdated = false
    
    init(userName: String = "Yule",
         profileImage: UIImage? = nil,
         kabinettNumber: String = "455-544",
         appleID: String = "figfigure33@gmail.com",
         selectedImageItem: PhotosPickerItem? = nil) {
        self.userName = userName
        self.profileImage = profileImage
        self.kabinettNumber = kabinettNumber
        self.appleID = appleID
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
    
    func completeProfileUpdate() {
        updateUserName()
        updateProfileImage()
        shouldNavigateToProfile = true
    }
}
