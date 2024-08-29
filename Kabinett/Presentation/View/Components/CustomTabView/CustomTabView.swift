//
//  CustomTabView.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI

struct CustomTabView<Content: View>: View {
    @StateObject private var imagePickerViewModel: ImagePickerViewModel
    @StateObject private var customTabViewModel: CustomTabViewModel
    @State private var letterWriteViewModel = LetterWriteViewModel()
    let content: Content
    
    init(componentsUseCase: ComponentsUseCase, componentsLoadStuffUseCase: ComponentsLoadStuffUseCase, @ViewBuilder content: () -> Content) {
        self._imagePickerViewModel = StateObject(wrappedValue: ImagePickerViewModel(componentsUseCase: componentsUseCase, componentsLoadStuffUseCase: componentsLoadStuffUseCase))
        self._customTabViewModel = StateObject(wrappedValue: CustomTabViewModel(tabs: CustomTabViewModel.defaultTabs()))
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            
            TabView(selection: $customTabViewModel.selectedTab) {
                content
            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $customTabViewModel.selectedTab, showOptions: $customTabViewModel.showOptions)
                    .padding(.horizontal, 20)
                    .frame(height: 60)
            }
            .edgesIgnoringSafeArea(.bottom)
            
            if customTabViewModel.showOptions {
                OptionOverlay(showOptions: $customTabViewModel.showOptions, showActionSheet: $customTabViewModel.showActionSheet, showWriteLetterView: $customTabViewModel.showWriteLetterView)
            }
        }
        .actionSheet(isPresented: $customTabViewModel.showActionSheet) {
            ActionSheet(
                title: Text("편지를 불러올 방법을 선택하세요."),
                buttons: [
                    .default(Text("촬영하기")) {
                        customTabViewModel.showCamera = true
                    },
                    .default(Text("앨범에서 가져오기")) {
                        customTabViewModel.showPhotoLibrary = true
                    },
                    .cancel(Text("취소"))
                ]
            )
        }
        .overlay(
            ImagePickerView(
                viewModel: imagePickerViewModel,
                showPhotoLibrary: $customTabViewModel.showPhotoLibrary,
                showImagePreview: $customTabViewModel.showImagePreview,
                showActionSheet: $customTabViewModel.showActionSheet
            )
        )
        .fullScreenCover(isPresented: $customTabViewModel.showCamera) {
            CameraView(imagePickerViewModel: imagePickerViewModel)
                .environmentObject(imagePickerViewModel)
        }
        .sheet(isPresented: $customTabViewModel.showWriteLetterView) {
            WriteLetterView(letterContent: $letterWriteViewModel)
        }
    }
}

// sample view

struct ProfileViewSample: View {
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack {
                Text("프로필")
            }
        }
    }
}

#Preview {
    CustomTabView(
        componentsUseCase: MockComponentsUseCase(),
        componentsLoadStuffUseCase: MockComponentsLoadStuffUseCase()
    ) {
        Text("편지보관")
            .tag(0)
        
        ProfileViewSample()
            .tag(2)
    }
}
