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
                print("Envelope URL: \(envelopeURL)")
                print("Stamp URL: \(stampURL)")
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.contentPrimary)
                .imageScale(.large)
        }
    }
    
    private var letterPreviewView: some View {
        ZStack {
            KFImage(URL(string: envelopeURL))
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .frame(width: 315, height: 145)
            
            GeometryReader { geometry in
                ZStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("보내는 사람")
                            .font(.system(size: 7))
                        Text(viewModel.fromUserName)
                            .font(.system(size: 14))
                    }
                    .position(x: 60, y: 35)
                    
                    Text(viewModel.formattedDate)
                        .font(.system(size: 12))
                        .position(x: geometry.size.width - 80, y: 25)
                    
                    Text(viewModel.postScript ?? letterContent.postScript ?? "")
                        .font(.system(size: 10))
                        .position(x: 85, y: geometry.size.height - 35)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("받는 사람")
                            .font(.system(size: 7))
                        Text(viewModel.toUserName)
                            .font(.system(size: 14))
                    }
                    .position(x: geometry.size.width - 90, y: geometry.size.height - 30)
                    
                    KFImage(URL(string: stampURL))
                        .resizable()
                        .placeholder {
                            ProgressView()
                        }
                        .frame(width: 34, height: 38)
                        .position(x: geometry.size.width - 40, y: 35)
                }
            }
        }
        .frame(width: 315, height: 145)
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
                print("Saving letter")
                await viewModel.saveImportingImage()
                dismiss()
            }
        }) {
            Text("편지 보관하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary900)
                .cornerRadius(14)
        }
        .padding(.horizontal)
        .disabled(viewModel.isLoading)
    }
}



//#Preview {
//    let firebaseFirestoreManager = FirebaseFirestoreManager(
//        authManager: RealAuthManager(),
//        writerManager: FirestoreWriterManager()
//    )
//
//    return LetterCompletionView(letterContent: .constant(LetterWriteModel()))
//        .environmentObject(ImagePickerViewModel(
//            componentsUseCase: firebaseFirestoreManager,
//            componentsLoadStuffUseCase: firebaseFirestoreManager,
//            authManager: RealAuthManager(),
//            writerManager: FirestoreWriterManager()
//        ))
//}
