//
//  CameraViewModel.swift
//  Kabinett
//
//  Created by 김정우 on 8/15/24.
//

import SwiftUI
import AVFoundation

// MARK: - ViewModel
final class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    
    // MARK: Method(캡쳐된 이미지 처리)
    func captureImage(with info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            capturedImage = image
        }
    }
}
