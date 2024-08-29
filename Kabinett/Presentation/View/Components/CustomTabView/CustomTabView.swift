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
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                LetterBoxView(letterBoxViewModel: LetterBoxViewModel(), letterBoxDetailViewModel: LetterBoxDetailViewModel())
                    .tag(0)
                
                Color.clear
                    .tag(1)
                
                ProfileView(profileViewModel: ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub()))
                    .tag(2)
            }
            .overlay(CustomTabBar(viewModel: viewModel), alignment: .bottom)
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
                    OptionOverlay(viewModel: viewModel)
                }
            }
        )
        .overlay(ImportDialog(viewModel: viewModel))
        .overlay(ImagePickerView(imageViewModel: imagePickerViewModel, customViewModel: viewModel))
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
