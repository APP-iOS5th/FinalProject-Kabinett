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
                        showLetterWritingView = true
                    }) {
                        Text("편지 선택하기")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary900)
                            .cornerRadius(15)
                    }
                    .padding()
                }
            }
            .navigationBarItems(leading: Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    customViewModel.showImportDialog = true
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.contentPrimary)
            })
            .navigationBarTitle("선택한 사진", displayMode: .inline)
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
    }
}
