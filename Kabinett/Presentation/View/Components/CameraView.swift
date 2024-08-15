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
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        CameraViewRepresentable(viewModel: viewModel)
            .edgesIgnoringSafeArea(.all)
            .onChange(of: viewModel.capturedImage) { _, _ in
                if let image = viewModel.capturedImage {
                    imagePickerViewModel.addImage(image)
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }
}
