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
    
    var body: some View {
        EmptyView()
            .photosPicker(
                isPresented: $customViewModel.showPhotoLibrary,
                selection: $imageViewModel.selectedItems,
                maxSelectionCount: 3,
                matching: .images
            )
            .onChange(of: imageViewModel.selectedItems) {
                Task {
                    await imageViewModel.loadImages()
                }
            }
            .onChange(of: imageViewModel.photoContents) { _, newContents in
                if !newContents.isEmpty {
                    customViewModel.showImagePreview = true
                }
            }
            .sheet(isPresented: $customViewModel.showImagePreview) {
                ImagePreview(customViewModel: customViewModel, imageViewModel: imageViewModel)
            }
    }
}
