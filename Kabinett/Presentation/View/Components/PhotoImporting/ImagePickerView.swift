//
//  ImagePickerView.swift
//  Kabinett
//
//  Created by 김정우 on 8/23/24.
//

import SwiftUI

struct ImagePickerView: View {
    @ObservedObject var viewModel: ImagePickerViewModel
    @Binding var showPhotoLibrary: Bool
    @Binding var showImagePreview: Bool
    @Binding var showActionSheet: Bool
    
    var body: some View {
        EmptyView()
            .photosPicker(
                isPresented: $showPhotoLibrary,
                selection: $viewModel.selectedItems,
                maxSelectionCount: 3,
                matching: .images
            )
            .onChange(of: viewModel.selectedItems) {
                Task {
                    await viewModel.loadImages()
                }
            }
            .onChange(of: viewModel.photoContents) { _, newContents in
                if !newContents.isEmpty {
                    showImagePreview = true
                }
            }
            .sheet(isPresented: $showImagePreview) {
                ImagePreivew(showActionSheet: $showActionSheet, viewModel: viewModel)
            }
    }
}
