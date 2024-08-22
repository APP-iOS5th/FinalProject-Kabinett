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
    @State private var selectedTab = 0
    @State private var showOptions = false
    @State private var showActionSheet = false
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var showImagePreview = false
    
    init(componentsUseCase: ComponentsUseCase) {
        self._imagePickerViewModel = StateObject(wrappedValue: ImagePickerViewModel(componentsUseCase: componentsUseCase))
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                LetterBoxView()
                    .tabItem {
                        Image(systemName: "tray.full")
                        Text("받은편지")
                    }
                    .tag(0)
                
                Color.clear
                    .tabItem {
                        Image(systemName: "plus")
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("프로필")
                    }
                    .tag(2)
            }
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == 1 {
                    withAnimation {
                        showOptions = true
                    }
                    selectedTab = oldValue
                }
            }
            
            if showOptions {
                OptionOverlay(showOptions: $showOptions, showActionSheet: $showActionSheet)
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
    }
}

// sample view
struct LetterBoxView: View {
    var body: some View {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack {
                Text("받은 편지")
            }
        }
    }
}


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


struct WriteLetterView: View {
    var body: some View {
        Text("이곳에서 편지를 작성하세요!")
            .padding()
            .navigationTitle("편지 쓰기")
    }
}


// MARK: - 프리뷰 더미 데이터
class DummyComponentsUseCase: ComponentsUseCase {
    func saveLetter(postScript: String?, envelope: String, stamp: String, fromUserId: String?, fromUserName: String, fromUserKabinettNumber: Int?, toUserId: String?, toUserName: String, toUserKabinettNumber: Int?, photoContents: [String], date: Date, isRead: Bool) async -> Result<Void, any Error> {
        return .success(())
    }
    
}

#Preview {
    CustomTabView(componentsUseCase: DummyComponentsUseCase())
}
