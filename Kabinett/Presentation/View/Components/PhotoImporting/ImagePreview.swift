//
//  ImagePreview.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import SwiftUI

struct ImagePreview: View {
    @EnvironmentObject var customViewModel: CustomTabViewModel
    @EnvironmentObject var imageViewModel: ImagePickerViewModel
    @EnvironmentObject var envelopeStampSelectionViewModel: EnvelopeStampSelectionViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showDetailView = false
    @State private var showLetterWritingView = false
    
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
            .navigationBarItems(leading: Button(action: {
                imageViewModel.resetSelections()
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if customViewModel.isLetterWrite == false {
                        customViewModel.showImportDialog = true
                    }
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary900)
            })
            .fullScreenCover(isPresented: $showDetailView) {
                ImageDetailView(images: imageViewModel.photoContents, showDetailView: $showDetailView)
            }
            .sheet(isPresented: $showLetterWritingView) {
                LetterWritingView()
                    .environmentObject(imageViewModel)
                    .environmentObject(customViewModel)
                    .environmentObject(envelopeStampSelectionViewModel)
            }
            .background(Color.background.edgesIgnoringSafeArea(.all))
        }
        .slideToDismiss {
            imageViewModel.resetSelections()
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if customViewModel.isLetterWrite == false {
                    customViewModel.showImportDialog = true
                }
            }
        }
    }
}
