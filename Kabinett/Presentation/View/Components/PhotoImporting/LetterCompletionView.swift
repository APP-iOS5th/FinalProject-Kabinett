//
//  LetterCompletionView.swift
//  Kabinett
//
//  Created by 김정우 on 8/20/24.
//

import SwiftUI
import Kingfisher

struct LetterCompletionView: View {
    @Binding var letterContent: LetterWriteModel
    @EnvironmentObject var viewModel: ImagePickerViewModel
    @EnvironmentObject var customTabViewModel: CustomTabViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var envelopeURL: String = ""
    @State private var stampURL: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()
                    letterPreviewView
                    completionMessageView
                    Spacer()
                    saveButton
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            Task {
                await viewModel.loadAndUpdateEnvelopeAndStamp()
                envelopeURL = viewModel.envelopeURL ?? letterContent.envelopeImageUrlString
                stampURL = viewModel.stampURL ?? letterContent.stampImageUrlString
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary900)
        }
    }
    
    private var letterPreviewView: some View {
        ZStack(alignment: .topLeading) {
            KFImage(URL(string: letterContent.envelopeImageUrlString))
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
                .aspectRatio(9/4, contentMode: .fit)
            
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        Text("보내는 사람")
                            .font(.system(size: 7))
                            .padding(.bottom, 1)
                        Text(viewModel.fromUserName)
                            .font(.system(size: 14))
                    }
                    .padding(.leading, 25)
                    
                    Spacer()
                }
                .padding(.top, 25)
                
                Spacer()
                
                HStack(alignment: .top) {
                    VStack {
                        Text(viewModel.postScript ?? letterContent.postScript ?? "")
                            .font(.system(size: 10))
                    }
                    .padding(.leading, 25)
                    
                    Spacer()
                    
                    VStack {
                        Text("받는 사람")
                            .font(.system(size: 7))
                            .padding(.bottom, 1)
                            .padding(.leading, -5)
                        Text(viewModel.toUserName)
                            .font(.system(size: 14))
                    }
                    .padding(.trailing, 100)
                }
                .padding(.bottom, 25)
            }
            
            
            KFImage(URL(string: letterContent.stampImageUrlString))
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .frame(width: 34, height: 38)
                .position(x: UIScreen.main.bounds.width * 0.75, y: 45)
            
            
            Text(viewModel.formattedDate)
                .monospaced()
                .font(.system(size: 12))
                .position(x: UIScreen.main.bounds.width * 0.7, y: 35)
        }
        .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.width * 0.85 * 4/9)
    }
    
    private var completionMessageView: some View {
        VStack(spacing: 10) {
            Text("편지가 완성되었어요.")
            Text("소중한 편지를 보관할게요.")
        }
        .font(.system(size: 18, weight: .medium))
    }
    
    private var saveButton: some View {
        Button(action: {
            Task {
                let success = await viewModel.saveImportingImage()
                if success {
                    customTabViewModel.navigateToLetterBox()
                    dismiss()
                    customTabViewModel.selectedTab = 0
                } else {
                    print("Failed to save letter")
                }
            }
        }) {
            Text("편지 보관하기")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(Color.primary900)
                .cornerRadius(16)
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
        .disabled(viewModel.isLoading)
    }
}
