//
//  ProfileSettingsViewModel.swift
//  Kabinett
//
//  Created by Yule on 8/15/24.
//

import SwiftUI
import Combine

class ProfileSettingsViewModel: ObservableObject {
    @Published var userName: String = "Yule"
    @Published var newUserName: String = ""
    @Published var profileImage: UIImage?
    
    var isUserNameVaild: Bool {
        return !newUserName.isEmpty
    }
    
    func updateUserName() {
        if isUserNameVaild {
            userName = newUserName
        }
    }
    
    func updateProfileImage(with image: UIImage?) {
        profileImage = image
    }
}
