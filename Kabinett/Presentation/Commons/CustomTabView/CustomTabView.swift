//
//  CustomTabView.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI

struct CustomTabView: View {
    @EnvironmentObject var viewModel: CustomTabViewModel
    @EnvironmentObject var imagePickerViewModel: ImagePickerViewModel
    @EnvironmentObject var letterBoxViewModel: LetterBoxViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    @State private var letterWriteViewModel = LetterWriteModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selectedTab) {
                LetterBoxView()
                    .tag(0)
                
                Color.clear
                    .tag(1)
                
                ProfileView()
                    .tag(2)
            }
            .overlay(CustomTabBar(viewModel: _viewModel), alignment: .bottom)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
                    OptionOverlay()
                }
                CalendarOverlayView()
            }
        )
        .overlay(ImportDialog())
        .overlay(ImagePickerView())
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            CameraView()
        }
        .sheet(isPresented: $viewModel.showWriteLetterView) {
            ContentWriteView(letterContent: $letterWriteViewModel)
        }
        .environmentObject(viewModel)
        .environmentObject(imagePickerViewModel)
    }
}
