//
//  CameraView.swift
//  Kabinett
//
//  Created by 김정우 on 8/15/24.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @EnvironmentObject var imagePickerViewModel: ImagePickerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        CameraViewRepresentable(viewModel: viewModel)
            .edgesIgnoringSafeArea(.all)
            .onChange(of: viewModel.capturedImage) { _, newImage in
                if let image = newImage,
                   let imageData = image.jpegData(compressionQuality: 0.5) {
                    imagePickerViewModel.photoContents.append(imageData)
                    dismiss()
                }
            }
    }
}

// MARK: - Camera View Representable
private struct CameraViewRepresentable: UIViewControllerRepresentable {
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
