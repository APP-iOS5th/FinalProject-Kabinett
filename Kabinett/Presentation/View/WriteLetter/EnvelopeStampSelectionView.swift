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
    @Binding var letter: WriteLetter
    @State private var postScriptText: String = ""
    @State private var envelopeImageUrl: String
    @State private var stampImageUrl: String
    @StateObject var viewModel: EnvelopeStampSelectionViewModel
    @ObservedObject var customTabViewModel: CustomTabViewModel
    
    init(
        letter: Binding<WriteLetter>,
        customTabViewModel: CustomTabViewModel
    ) {
        self.customTabViewModel = customTabViewModel
        self._letter = letter
        
        _envelopeImageUrl = State(initialValue: letter.wrappedValue.envelopeImageUrlString)
        _stampImageUrl = State(initialValue: letter.wrappedValue.stampImageUrlString)
        
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
                WriteLetterEnvelopeCell(letter: letter, postScript: postScriptText)
                    .padding(.top, 10)
                    .padding(.bottom, 50)
                    .onChange(of: viewModel.envelopes) {
                        if letter.envelopeImageUrlString.isEmpty {
                            envelopeImageUrl = viewModel.envelopes[0]
                        }
                    }
                    .onChange(of: viewModel.stamps) {
                        if letter.stampImageUrlString.isEmpty {
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
                            letter.postScript = postScriptText
                        }
                }
                .padding(.bottom, 30)
                
                SelectionTabView(envelopeStampSelectionViewModel: viewModel, letter: $letter, envelopeImageUrl: $envelopeImageUrl, stampImageUrl: $stampImageUrl)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
        }
        .task {
            await viewModel.loadStamps()
            await viewModel.loadEnvelopes()
            envelopeImageUrl = letter.envelopeImageUrlString
            stampImageUrl = letter.stampImageUrlString
        }
        .onChange(of: envelopeImageUrl) { _, newValue in
            letter.envelopeImageUrlString = newValue
        }
        .onChange(of: stampImageUrl) { _, newValue in
            letter.stampImageUrlString = newValue
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("봉투와 우표 고르기")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: PreviewLetterView(
                    letter: $letter,
                    customTabViewModel: customTabViewModel
                )) {
                    Text("다음")
                        .fontWeight(.medium)
                        .font(.system(size: 19))
                        .foregroundStyle(.contentPrimary)
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
