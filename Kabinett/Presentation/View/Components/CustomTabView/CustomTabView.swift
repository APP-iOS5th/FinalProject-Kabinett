//
//  CustomTabView.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI

struct CustomTabView: View {
    @StateObject private var viewModel: CustomTabViewModel
    @StateObject private var imagePickerViewModel: ImagePickerViewModel
    @State private var letterWriteViewModel = LetterWriteViewModel()
    
    init(componentsUseCase: ComponentsUseCase, componentsLoadStuffUseCase: ComponentsLoadStuffUseCase) {
        self._viewModel = StateObject(wrappedValue: CustomTabViewModel())
        self._imagePickerViewModel = StateObject(wrappedValue: ImagePickerViewModel(componentsUseCase: componentsUseCase, componentsLoadStuffUseCase: componentsLoadStuffUseCase))
    }
    
    var body: some View {
        ZStack() {
            TabView(selection: $viewModel.selectedTab) {
                LetterBoxView(viewModel: LetterBoxViewModel())
                    .tabItem {
                        Image(uiImage: viewModel.envelopeImage)
                    }
                    .tag(0)
                
                Color.clear
                    .tabItem {
                        Image(uiImage: viewModel.plusImage)
                    }
                    .tag(1)
                
                ProfileView(viewModel: ProfileSettingsViewModel())
                    .tabItem {
                        Image(uiImage: viewModel.profileImage)
                    }
                    .tag(2)
            }
        }
        .onAppear {
            viewModel.setupTabBarAppearance()
        }
        .onChange(of: viewModel.selectedTab) { oldValue, newValue in
            if newValue == 1 {
                withAnimation {
                    viewModel.showOptions = true
                }
                viewModel.selectedTab = oldValue
            }
        }
        .overlay(
            Group {
                if viewModel.showOptions {
                    OptionOverlay(
                        showOptions: $viewModel.showOptions,
                        showActionSheet: $viewModel.showActionSheet,
                        showWriteLetterView: $viewModel.showWriteLetterView
                    )
                }
            }
        )
        .actionSheet(isPresented: $viewModel.showActionSheet) {
            ActionSheet(
                title: Text("편지를 불러올 방법을 선택하세요."),
                buttons: [
                    .default(Text("촬영하기")) { viewModel.showCamera = true },
                    .default(Text("앨범에서 가져오기")) { viewModel.showPhotoLibrary = true },
                    .cancel(Text("취소"))
                ]
            )
        }
        .overlay(
            ImagePickerView(
                viewModel: imagePickerViewModel,
                showPhotoLibrary: $viewModel.showPhotoLibrary,
                showImagePreview: $viewModel.showImagePreview,
                showActionSheet: $viewModel.showActionSheet
            )
        )
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            CameraView(imagePickerViewModel: imagePickerViewModel)
                .environmentObject(imagePickerViewModel)
        }
        .sheet(isPresented: $viewModel.showWriteLetterView) {
            WriteLetterView(letterContent: $letterWriteViewModel)
        }
    }
    
}



#Preview {
    CustomTabView(
        componentsUseCase: MockComponentsUseCase(),
        componentsLoadStuffUseCase: MockComponentsLoadStuffUseCase()
    )
}
