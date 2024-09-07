//
//  LetterBoxDetailLetterView.swift
//  Kabinett
//
//  Created by uunwon on 8/28/24.
//

import SwiftUI

struct LetterBoxDetailLetterView: View {
    @EnvironmentObject var viewModel: LetterViewModel
    @EnvironmentObject var letterBoxDetailViewModel: LetterBoxDetailViewModel
    
    @State private var showDetailLetter = false
    
    @State private var offset: CGFloat = 0
    @State private var showDeleteButton = false
    
    var letterType: LetterType
    var letter: Letter
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .trailing) {
                if showDeleteButton {
                    Button(action: {
                        guard let letterId = letter.id else { return }
                        viewModel.deleteLetter(letterId: letterId, letterType: letterType)
                        dismiss()
                    }) {
                        Text("삭제하기")
                            .font(.system(size: 16))
                            .foregroundColor(.alert)
                    }
                    .padding(.trailing, letter.isRead ? -20 : -5)
                }
                
                HStack {
                    LetterBoxDetailEnvelopeCell(letter: letter)
                        .onTapGesture {
                            if !letter.isRead {
                                guard let letterId = letter.id else { return }
                                viewModel.updateLetterReadStatus(letterId: letterId, letterType: letterType)
                                letterBoxDetailViewModel.fetchLetterBoxDetailLetters(letterType: letterType)
                            }
                            showDetailLetter = true
                        }
                }
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            DragHelper.handleDragGesture(value: value, offset: &offset, showDeleteButton: &showDeleteButton)
                        }
                        .onEnded { _ in
                            DragHelper.handleDragEnd(offset: &offset, showDeleteButton: &showDeleteButton)
                        }
                )
                .animation(.spring(), value: offset)
            }
        }
        .navigationTitle(letterType.description)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView(action: { dismiss() }))
        .fullScreenCover(isPresented: $showDetailLetter) {
            LetterCell(letter: letter)
        }
    }
}



//#Preview {
//    LetterBoxDetailLetterView(letterType: .all, letter: LetterBoxUseCaseStub.sampleSearchOfKeywordLetters[0])
//        .environmentObject(LetterViewModel())
//}
