//
//  OptionOverlay.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI

struct OptionOverlay: View {
    @EnvironmentObject var viewModel: CustomTabViewModel
    @State var letterContent = LetterWriteModel()
    
    @State private var isWritingLetter = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation() {
                        viewModel.hideOptions()
                    }
                }
            
            VStack {
                Spacer()
                
                HStack(spacing: 2) {
                    Button(action: {
                        viewModel.showImportDialogAndHideOptions()
                        viewModel.hideOptions()
                    }) {
                        Text("편지 불러오기")
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity)
                            .frame(height: 24)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        isWritingLetter = true
                    }) {
                        Text("편지 쓰기")
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity)
                            .frame(height: 24)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                    }
                }
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, viewModel.getSafeAreaBottom())
            }
            .transition(.move(edge: .bottom))
        }
        .fullScreenCover(isPresented: $isWritingLetter) {
            StationerySelectionView(letterContent: $letterContent)
                .ignoresSafeArea()
        }
    }
}
