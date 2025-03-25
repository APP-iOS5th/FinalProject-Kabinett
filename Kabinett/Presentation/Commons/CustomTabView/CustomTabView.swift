//
//  CustomTabView.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI

struct CustomTabView: View {
    @StateObject private var customTabViewModel = CustomTabViewModel()
    @StateObject private var profileViewModel: ProfileViewModel
    @StateObject private var envelopeStampSelectionViewModel: EnvelopeStampSelectionViewModel
    @State private var letterWriteModel = LetterWriteModel()
    
    init() {
        @Injected(LetterBoxUseCaseKey.self) var letterBoxUseCase: LetterBoxUseCase
        @Injected(ProfileUseCaseKey.self) var profileUseCase: ProfileUseCase
        @Injected(WriteLetterUseCaseKey.self) var writeLetterUseCase: WriteLetterUseCase
        
        self._customTabViewModel = StateObject(wrappedValue: CustomTabViewModel())
        self._profileViewModel = StateObject(wrappedValue: ProfileViewModel(profileUseCase: profileUseCase))
        self._envelopeStampSelectionViewModel = StateObject(wrappedValue: EnvelopeStampSelectionViewModel(useCase: writeLetterUseCase))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $customTabViewModel.selectedTab) {
                LetterBoxView(customTabViewModel: customTabViewModel)
                    .tag(0)
                
                Color.clear
                    .tag(1)
                
                ProfileView(customTabViewModel: customTabViewModel)
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
                    customTabViewModel.showWriteView = true
                }
                customTabViewModel.selectedTab = oldValue
            }
        }
        .sheet(isPresented: $customTabViewModel.showWriteView) {
            UserSelectionView(letter: $letterWriteModel.writeLetter, customViewModel: customTabViewModel)
                .presentationDetents([.height(300), .large])
        }
    }
}
