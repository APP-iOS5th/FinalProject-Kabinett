//
//  ImagePickerView.swift
//  Kabinett
//
//  Created by 김정우 on 8/23/24.
//

import SwiftUI

struct ImagePickerView: View {
    @EnvironmentObject var imageViewModel: ImagePickerViewModel
    @EnvironmentObject var customViewModel: CustomTabViewModel
    
    var body: some View {
        EmptyView()
            .photosPicker(
                isPresented: $customViewModel.showPhotoLibrary,
                selection: $imageViewModel.selectedItems,
                maxSelectionCount: 3,
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
            .sheet(isPresented: $customViewModel.showImagePreview) {
                ImagePreview()
                    .environmentObject(imageViewModel)
                    .environmentObject(customViewModel)
            }
    }
}
