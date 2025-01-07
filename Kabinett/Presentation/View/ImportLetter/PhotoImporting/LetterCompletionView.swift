//
//  LetterCompletionView.swift
//  Kabinett
//
//  Created by 김정우 on 8/20/24.
//

import FirebaseAnalytics
import SwiftUI
import Kingfisher

struct LetterCompletionView: View {
    @Binding var letterContent: LetterWriteModel
    @ObservedObject var viewModel: ImagePickerViewModel
    @ObservedObject var customTabViewModel: CustomTabViewModel
    @ObservedObject var envelopeStampSelectionViewModel: EnvelopeStampSelectionViewModel
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
        .onAppear {
            Task {
                await viewModel.loadAndUpdateEnvelopeAndStamp()
                envelopeURL = viewModel.envelopeURL ?? letterContent.envelopeImageUrlString
                stampURL = viewModel.stampURL ?? letterContent.stampImageUrlString
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
                    VStack(alignment: .leading, spacing: 2) {
                        Text("보내는 사람")
                            .font(.system(size: 7))
                            .foregroundStyle(.contentPrimary)
                        Text(viewModel.fromUserName)
                            .font(.system(size: 14))
                            .foregroundStyle(.contentPrimary)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.57, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    ZStack(alignment: .topTrailing) {
                        KFImage(URL(string: letterContent.stampImageUrlString))
                            .resizable()
                            .placeholder {
                                ProgressView()
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.09, height: UIScreen.main.bounds.height * 0.046)
                            .aspectRatio(contentMode: .fit)
                        
                        Text(viewModel.formattedDate)
                            .monospaced()
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(2)
                            .background(Color.clear)
                            .cornerRadius(4)
                            .offset(x: -UIScreen.main.bounds.width * 0.06, y: -UIScreen.main.bounds.height * 0.005)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 25)
                
                Spacer()
                
                HStack(alignment: .top) {
                    Text(viewModel.postScript ?? letterContent.postScript ?? "")
                        .font(.system(size: 10))
                        .foregroundStyle(.contentPrimary)
                        .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .leading)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("받는 사람")
                            .font(.system(size: 7))
                            .foregroundStyle(.contentPrimary)
                        Text(viewModel.toUserName)
                            .font(.system(size: 14))
                            .foregroundStyle(.contentPrimary)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.26, alignment: .leading)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 25)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.width * 0.85 * 4/9)
    }
    
    private var completionMessageView: some View {
        VStack(spacing: 10) {
            Text("편지가 완성되었어요.")
            Text("소중한 편지를 보관할게요.")
        }
        .font(.system(size: 18, weight: .semibold))
    }
    
    private var saveButton: some View {
        Button(action: {
            customTabViewModel.navigateToLetterBox()
            dismiss()
            customTabViewModel.selectedTab = 0
            
            Task {
                if viewModel.postScript == nil {
                    viewModel.postScript = letterContent.postScript
                }
                
                let success = await viewModel.saveImportingImage()
                if !success {
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
