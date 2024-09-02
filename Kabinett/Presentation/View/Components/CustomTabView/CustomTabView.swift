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
    @State private var letterWriteViewModel = LetterWriteModel()
    @EnvironmentObject var letterBoxViewModel: LetterBoxViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                LetterBoxView()
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
            } else {
                if newValue == 0 {
                    //                             LetterBoxViewState.reset()
                } else if newValue == 2 {
                    //                            ProfileViewState.reset()
                }
            }
        }
        .overlay(
            Group {
                if viewModel.showOptions {
                    OptionOverlay(viewModel: viewModel)
                }
                CalendarOverlayView()
            }
        )
        .overlay(ImportDialog(viewModel: viewModel))
        .overlay(ImagePickerView())
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            CameraView()
        }
        .sheet(isPresented: $viewModel.showWriteLetterView) {
            WriteLetterView(letterContent: $letterWriteViewModel)
        }
        .environmentObject(viewModel)
        .environmentObject(imagePickerViewModel)
        
    }
}

//#Preview {
//    CustomTabView()
//        .environmentObject(CustomTabViewModel())
//        .environmentObject(ImagePickerViewModel(
//            componentsUseCase: MockComponentsUseCase(),
//            componentsLoadStuffUseCase: MockComponentsLoadStuffUseCase()
//        ))
//        .environmentObject(CalendarViewModel())
//        .environmentObject(LetterBoxDetailViewModel())
//        .environmentObject(LetterBoxViewModel())
//}
