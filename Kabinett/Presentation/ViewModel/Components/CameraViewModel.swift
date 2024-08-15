//
//  CameraViewModel.swift
//  Kabinett
//
//  Created by 김정우 on 8/15/24.
//

import SwiftUI
import AVFoundation

final class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    
    // MARK: Image capture Methods
    func captureImage(with info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            capturedImage = image
        }
    }
}
    
