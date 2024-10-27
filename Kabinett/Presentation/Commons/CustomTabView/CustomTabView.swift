//
//  CustomTabView.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI

struct CustomTabView: View {
    @StateObject private var customTabViewModel: CustomTabViewModel
    @StateObject private var calendarViewModel: CalendarViewModel
    @StateObject private var profileViewModel: ProfileViewModel
    
    @State private var letterWriteViewModel = LetterWriteModel()
    
    init() {
        @Injected(LetterBoxUseCaseKey.self) var letterBoxUseCase: LetterBoxUseCase
        @Injected(ProfileUseCaseKey.self) var profileUseCase: ProfileUseCase
        
        self._customTabViewModel = StateObject(wrappedValue: CustomTabViewModel())
        self._calendarViewModel = StateObject(wrappedValue: CalendarViewModel())
        self._profileViewModel = StateObject(wrappedValue: ProfileViewModel(profileUseCase: profileUseCase))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $customTabViewModel.selectedTab) {
                LetterBoxView()
                    .tag(0)
                
                Color.clear
                    .tag(1)
                
                ProfileView()
                    .tag(2)
            }
            .overlay(
                CustomTabBar(
                    viewModel: customTabViewModel,
                    profileViewModel: profileViewModel
                ),
                alignment: .bottom
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            customTabViewModel.setupTabBarAppearance()
        }
        .onChange(of: customTabViewModel.selectedTab) { oldValue, newValue in
            if newValue == 1 {
                withAnimation {
                    customTabViewModel.showOptions = true
                }
                customTabViewModel.selectedTab = oldValue
            }
        }
        .overlay(
            Group {
                if customTabViewModel.showOptions {
                    OptionOverlay()
                }
                CalendarOverlayView()
            }
        )
        .overlay(ImportDialog())
        .overlay(ImagePickerView())
        .fullScreenCover(isPresented: $customTabViewModel.showCamera) {
            CameraView()
        }
        .sheet(isPresented: $customTabViewModel.showWriteLetterView) {
            ContentWriteView(letterContent: $letterWriteViewModel)
        }
    }
}
