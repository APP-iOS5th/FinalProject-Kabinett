//
//  CameraViewRepresentable.swift
//  Kabinett
//
//  Created by 김정우 on 8/15/24.
//

import SwiftUI

// MARK: - Camera View Representable
struct CameraViewRepresentable: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: Coordinator (UIImagePickerController Coordinator)
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraViewRepresentable
        
        init(_ parent: CameraViewRepresentable) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.viewModel.captureImage(with: info)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
