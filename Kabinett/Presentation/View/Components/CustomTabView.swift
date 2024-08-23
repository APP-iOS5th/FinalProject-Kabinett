//
//  CustomTabView.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI

struct CustomTabView: View {
    @StateObject private var imagePickerViewModel: ImagePickerViewModel
    @State private var letterWriteViewModel = LetterWriteViewModel()
    @State private var selectedTab = 0
    @State private var showOptions = false
    @State private var showActionSheet = false
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var showImagePreview = false
    @State private var showWriteLetterView = false
    
    init(componentsUseCase: ComponentsUseCase) {
        self._imagePickerViewModel = StateObject(wrappedValue: ImagePickerViewModel(componentsUseCase: componentsUseCase))
    }
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            
            TabView(selection: $selectedTab) {
                LetterBoxView()
                    .tag(0)
                
                Color.clear
                    .tag(1)
                
                ProfileView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab, showOptions: $showOptions)
                    .padding(.horizontal, 20)
                    .frame(height: 75)
            }
            .edgesIgnoringSafeArea(.bottom)
            
            if showOptions {
                OptionOverlay(showOptions: $showOptions, showActionSheet: $showActionSheet, showWriteLetterView: $showWriteLetterView)
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("편지를 불러올 방법을 선택하세요."),
                buttons: [
                    .default(Text("촬영하기")) {
                        showCamera = true
                    },
                    .default(Text("앨범에서 가져오기")) {
                        showPhotoLibrary = true
                    },
                    .cancel(Text("취소"))
                ]
            )
        }
        .photosPicker(
            isPresented: $showPhotoLibrary,
            selection: $imagePickerViewModel.selectedItems,
            maxSelectionCount: 3,
            matching: .images
        )
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(imagePickerViewModel: imagePickerViewModel)
                .environmentObject(imagePickerViewModel)
        }
        .onChange(of: imagePickerViewModel.photoContents) { _, newContents in
            if !newContents.isEmpty {
                showImagePreview = true
            }
        }
        .sheet(isPresented: $showImagePreview) {
            ImagePreivew(showActionSheet: $showActionSheet, viewModel: imagePickerViewModel)
        }
        .sheet(isPresented: $showWriteLetterView) {
            WriteLetterView(letterContent: $letterWriteViewModel)
        }
    }
}

// sample view

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack {
                Text("프로필")
            }
        }
    }
}


// Preview 더미 데이터
class DummyComponentsUseCase: ComponentsUseCase {
    func saveLetter(postScript: String?,
                    envelope: String,
                    stamp: String,
                    fromUserId: String?,
                    fromUserName: String,
                    fromUserKabinettNumber: Int?,
                    toUserId: String?,
                    toUserName: String,
                    toUserKabinettNumber: Int?,
                    photoContents: [Data],
                    date: Date,
                    isRead: Bool
    ) async -> Result<Bool, any Error> {
        return .success(true)
    }
}

#Preview {
    CustomTabView(componentsUseCase: DummyComponentsUseCase())
}
