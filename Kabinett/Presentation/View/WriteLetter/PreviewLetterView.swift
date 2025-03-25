//
//  LetterWritePreviewView.swift
//  Kabinett
//
//  Created by Song Kim on 8/29/24.
//

import SwiftUI
import Kingfisher
import UIKit
import FirebaseAnalytics

struct PreviewLetterView: View {
    @Binding var letter: WriteLetter
    @StateObject var viewModel: PreviewLetterViewModel
    @ObservedObject var customTabViewModel: CustomTabViewModel
    
    init(
        letter: Binding<WriteLetter>,
        customTabViewModel: CustomTabViewModel
    ) {
        self.customTabViewModel = customTabViewModel
        self._letter = letter
        @Injected(WriteLetterUseCaseKey.self) var writeLetterUseCase: WriteLetterUseCase
        _viewModel = StateObject(wrappedValue: PreviewLetterViewModel(useCase: writeLetterUseCase))
    }
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            VStack {
                Spacer()
                WriteLetterEnvelopeCell(letter: letter)
                    .padding(.bottom,30)
                
                VStack {
                    Text("편지가 완성되었어요.")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("\(letter.toUserName == letter.fromUserName ? "나" : letter.toUserName)")
                            .font(.system(size: 22, weight: .bold))
                            .padding(.trailing, -3)
                        Text("에게 편지를 보낼까요?")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding(.top, -5)
                }
                
                Spacer()
                
                Button {
                    viewModel.saveLetter(letter: letter)
                    customTabViewModel.hideWriteView()
                } label: {
                    Text("편지 보내기")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 56)
                }
                .background(Color("Primary900"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
            .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.03, forOthers: 0.0))
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
