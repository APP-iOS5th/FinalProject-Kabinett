//
//  ImagePreview.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import FirebaseAnalytics
import SwiftUI

struct ImagePreview: View {
    @ObservedObject private var imageViewModel: ImagePickerViewModel
    @ObservedObject private var customViewModel: CustomTabViewModel
    @ObservedObject private var envelopeStampSelectionViewModel: EnvelopeStampSelectionViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showDetailView = false
    @State private var showLetterWritingView = false
    @State private var navigateToEnvelopeStamp = false
    @State private var letterContent = LetterWriteModel()
    
    init(
        imageViewModel: ImagePickerViewModel,
        customViewModel: CustomTabViewModel,
        envelopeStampSelectionViewModel: EnvelopeStampSelectionViewModel
    ) {
        self.imageViewModel = imageViewModel
        self.customViewModel = customViewModel
        self.envelopeStampSelectionViewModel = envelopeStampSelectionViewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    OverlappingImagesView(images: imageViewModel.photoContents, showDetailView: $showDetailView)
                    Spacer()
                    Button(action: {
                        if customViewModel.isLetterWrite {
                            dismiss()
                        } else {
                            showLetterWritingView = true
                        }
                    }) {
                        Text(customViewModel.isLetterWrite ? "사진 동봉하기" : "편지 선택하기")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(Color.primary900)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    imageViewModel.resetSelections()
                    customViewModel.showImagePreview = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        customViewModel.showPhotoLibrary = true
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.contentPrimary)
                }
            )
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .navigationDestination(isPresented: $showDetailView) {
                ImageDetailView(
                    images: imageViewModel.photoContents,
                    showDetailView: $showDetailView
                )
            }
            .sheet(isPresented: $showLetterWritingView) {
                LetterWritingView(
                    viewModel: imageViewModel,
                    customViewModel: customViewModel,
                    envelopeStampViewModel: envelopeStampSelectionViewModel,
                    letterContent: $letterContent,
                    showEnvelopeStamp: $navigateToEnvelopeStamp
                )
            }
            .navigationDestination(isPresented: $navigateToEnvelopeStamp) {
                EnvelopeStampSelectionView(
                    letterContent: $letterContent,
                    customTabViewModel: customViewModel,
                    imageViewModel: imageViewModel
                )
            }
        }
        .onDisappear {
            imageViewModel.resetSelections()
            if !customViewModel.isLetterWrite && !customViewModel.letterBoxNavigationPath.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    customViewModel.showImportDialog = true
                }
            }
        }
        .analyticsScreen(
            name: "\(type(of:self))",
            extraParameters: [
                AnalyticsParameterScreenName: "\(type(of:self))",
                AnalyticsParameterScreenClass: "\(type(of:self))",
            ]
        )
    }
}
