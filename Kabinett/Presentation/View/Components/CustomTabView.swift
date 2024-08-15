//
//  CustomTabView.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI

struct CustomTabView: View {
    @State private var selectedTab = 0
    @State private var showOptions = false
    @State private var showActionSheet = false
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @StateObject private var imagePickerViewModel = ImagePickerViewModel()
    
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
            .onChange(of: selectedTab) { PreviousTab, currentTab in
                if currentTab == 1 {
                    withAnimation {
                        showOptions = true
                    }
                    selectedTab = PreviousTab
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
        .photosPicker(isPresented: $showPhotoLibrary, selection: $imagePickerViewModel.selectedItems, maxSelectionCount: 3, matching: .images)
        .onChange(of: imagePickerViewModel.selectedItems) { _, _ in
            imagePickerViewModel.loadImages()
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

#Preview {
    CustomTabView()
}
