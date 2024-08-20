//
//  ProfileSettingsViewModel.swift
//  Kabinett
//
//  Created by Yule on 8/15/24.
//

import SwiftUI
import Combine

class ProfileSettingsViewModel: ObservableObject {
    @Published var userName: String
    @Published var newUserName: String = ""
    @Published var profileImage: UIImage?
    @Published var kabinettNumber: String
    @Published var appleID: String
    @Published var shouldNavigateToSettings = false
    @Published var shouldNavigateToProfile = false
    @Published var selectedImage: UIImage?
    @Published var isShowingImagePicker = false
    @Published var isShowingCropper = false
    
    init(userName: String = "Yule",
         profileImage: UIImage? = nil,
         kabinettNumber: String = "455-544",
         appleID: String = "figfigure33@gmail.com") {
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
    
    func cropImage(_ uiImage: UIImage, in containerSize: CGSize, zoomScale: CGFloat, dragOffset: CGSize, cropSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: cropSize)
        return renderer.image { _ in
            let cropOriginX = (containerSize.width / 2 - cropSize.width / 2) - dragOffset.width
            let cropOriginY = (containerSize.height / 2 - cropSize.height / 2) - dragOffset.height
            let origin = CGPoint(x: cropOriginX, y: cropOriginY)
            let rect = CGRect(origin: origin, size: CGSize(width: uiImage.size.width * zoomScale, height: uiImage.size.height * zoomScale))
            uiImage.draw(in: rect)
        }
    }
    
    func updateProfileImage(with croppedImage: UIImage?) {
        if let croppedImage = croppedImage {
            self.profileImage = croppedImage
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
        updateProfileImage(with: profileImage)
        shouldNavigateToProfile = true
    }
}
