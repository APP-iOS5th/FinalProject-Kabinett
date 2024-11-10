//
//  ImagePickerView.swift
//  Kabinett
//
//  Created by 김정우 on 8/23/24.
//

import SwiftUI

struct ImagePickerView: View {
    @ObservedObject var imageViewModel: ImagePickerViewModel
    @ObservedObject var customViewModel: CustomTabViewModel
    @ObservedObject var envelopeStampSelectionViewModel: EnvelopeStampSelectionViewModel
    
    var body: some View {
        EmptyView()
            .photosPicker(
                isPresented: $customViewModel.showPhotoLibrary,
                selection: $imageViewModel.selectedItems,
                maxSelectionCount: 10,
                matching: .images
            )
            .onChange(of: imageViewModel.selectedItems) { _, newValue in
                Task { @MainActor in
                    imageViewModel.selectedItems = newValue
                    await imageViewModel.loadImages()
                }
            }
        
            .onChange(of: imageViewModel.photoContents) { _, newContents in
                if !newContents.isEmpty {
                    customViewModel.showImagePreview = true
                }
            }
            .fullScreenCover(isPresented: $customViewModel.showImagePreview) {
                ImagePreview(
                    imageViewModel: imageViewModel,
                    customViewModel: customViewModel,
                    envelopeStampSelectionViewModel: envelopeStampSelectionViewModel
                )
            }
    }
}
