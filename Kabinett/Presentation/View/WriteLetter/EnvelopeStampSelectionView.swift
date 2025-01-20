//
//  EnvelopeSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/27/24.
//

import SwiftUI
import Kingfisher
import FirebaseAnalytics

struct EnvelopeStampSelectionView: View {
    @Binding var letterContent: LetterWriteModel
    @StateObject var viewModel: EnvelopeStampSelectionViewModel
    @ObservedObject var imageViewModel: ImagePickerViewModel
    @ObservedObject var customTabViewModel: CustomTabViewModel
    @State private var postScriptText: String = ""
    @State private var envelopeImageUrl: String
    @State private var stampImageUrl: String
    
    init(
        letterContent: Binding<LetterWriteModel>,
        customTabViewModel: CustomTabViewModel,
        imageViewModel: ImagePickerViewModel
    ) {
        self._letterContent = letterContent
        self.imageViewModel = imageViewModel
        self.customTabViewModel = customTabViewModel
        
        _envelopeImageUrl = State(initialValue: letterContent.wrappedValue.envelopeImageUrlString)
        _stampImageUrl = State(initialValue: letterContent.wrappedValue.stampImageUrlString)
        
        @Injected(WriteLetterUseCaseKey.self) var writeLetterUseCase: WriteLetterUseCase
        _viewModel = StateObject(wrappedValue: EnvelopeStampSelectionViewModel(useCase: writeLetterUseCase))
    }
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                WriteLetterEnvelopeCell(letter: Letter(fontString: letterContent.fontString, postScript: postScriptText, envelopeImageUrlString: letterContent.envelopeImageUrlString, stampImageUrlString: letterContent.stampImageUrlString, fromUserId: letterContent.fromUserId, fromUserName: letterContent.fromUserName, fromUserKabinettNumber: letterContent.fromUserKabinettNumber, toUserId: letterContent.toUserId, toUserName: letterContent.toUserName, toUserKabinettNumber: letterContent.toUserKabinettNumber, content: letterContent.content, photoContents: [""], date: letterContent.date, stationeryImageUrlString: letterContent.stationeryImageUrlString, isRead: true))
                    .padding(.top, 10)
                    .padding(.bottom, 50)
                    .onChange(of: viewModel.envelopes) {
                        if letterContent.envelopeImageUrlString.isEmpty {
                            envelopeImageUrl = viewModel.envelopes[0]
                        }
                    }
                    .onChange(of: viewModel.stamps) {
                        if letterContent.stampImageUrlString.isEmpty {
                            stampImageUrl = viewModel.stamps[0]
                        }
                    }
                
                VStack(alignment: .leading) {
                    Text("봉투에 적을 내용")
                        .font(.system(size: 13))
                        .padding(.bottom, 1)
                    TextField("최대 15글자를 적을 수 있어요.", text: $postScriptText)
                        .maxLength(text: $postScriptText, 15)
                        .padding(.leading, 6)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, minHeight: 35, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .onChange(of: postScriptText) {
                            letterContent.postScript = postScriptText
                        }
                }
                .padding(.bottom, 30)
                
                SelectionTabView(envelopeStampSelectionViewModel: viewModel, letterContent: $letterContent, envelopeImageUrl: $envelopeImageUrl, stampImageUrl: $stampImageUrl)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
        }
        .task {
            await viewModel.loadStamps()
            await viewModel.loadEnvelopes()
            
            if letterContent.dataSource == .importLetter {
                await imageViewModel.loadAndUpdateEnvelopeAndStamp()
                envelopeImageUrl = imageViewModel.envelopeURL ?? ""
                stampImageUrl = imageViewModel.stampURL ?? ""
            } else {
                await imageViewModel.loadAndUpdateEnvelopeAndStamp()
                envelopeImageUrl = letterContent.envelopeImageUrlString
                stampImageUrl = letterContent.stampImageUrlString
            }
        }
        .onChange(of: envelopeImageUrl) { _, newValue in
            imageViewModel.updateEnvelopeAndStamp(envelope: newValue, stamp: stampImageUrl)
            letterContent.envelopeImageUrlString = newValue
        }
        .onChange(of: stampImageUrl) { _, newValue in
            imageViewModel.updateEnvelopeAndStamp(envelope: envelopeImageUrl, stamp: newValue)
            letterContent.stampImageUrlString = newValue
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("봉투와 우표 고르기")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if letterContent.dataSource == .importLetter {
                    NavigationLink(destination: LetterCompletionView(
                        letterContent: $letterContent,
                        viewModel: imageViewModel,
                        customTabViewModel: customTabViewModel,
                        envelopeStampSelectionViewModel: viewModel
                    )) {
                        Text("다음")
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundStyle(.contentPrimary)
                    }
                } else {
                    NavigationLink(destination: PreviewLetterView(
                        letterContent: $letterContent,
                        customTabViewModel: customTabViewModel,
                        imagePickerViewModel: imageViewModel
                    )) {
                        Text("다음")
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundStyle(.contentPrimary)
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .analyticsScreen(
            name: "\(type(of:self))",
            extraParameters: [
                AnalyticsParameterScreenName: "\(type(of:self))",
                AnalyticsParameterScreenClass: "\(type(of:self))",
            ]
        )
    }
}
