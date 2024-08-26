//
//  CameraView.swift
//  Kabinett
//
//  Created by 김정우 on 8/15/24.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @ObservedObject var imagePickerViewModel: ImagePickerViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        CameraViewRepresentable(viewModel: viewModel)
            .edgesIgnoringSafeArea(.all)
            .onChange(of: viewModel.capturedImage) { _, newImage in
                if let image = newImage,
                   let imageData = image.jpegData(compressionQuality: 0.5) {
                    imagePickerViewModel.photoContents.append(imageData)
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }
}
