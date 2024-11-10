//
//  LetterView.swift
//  Kabinett
//
//  Created by uunwon on 8/28/24.
//

import SwiftUI

struct LetterView: View {
    @StateObject var viewModel: LetterViewModel
    
    @State private var showDetailLetter = false
    
    @State private var offset: CGFloat = 0
    @State private var showDeleteButton = false
    
    @State private var letter: Letter
    var letterType: LetterType
    
    @Environment(\.dismiss) private var dismiss
    
    init(letterType: LetterType, letter: Letter) {
        @Injected(LetterBoxUseCaseKey.self) var letterBoxUseCase: LetterBoxUseCase
        _viewModel = StateObject(wrappedValue: LetterViewModel(letterBoxUseCase: letterBoxUseCase))
        
        self.letterType = letterType
        _letter = State(initialValue: letter)
    }
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
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
                        LargeEnvelopeCell(letter: letter)
                            .onTapGesture {
                                if !letter.isRead {
                                    letter.isRead = true
                                    
                                    guard let letterId = letter.id else { return }
                                    viewModel.updateLetterReadStatus(letterId: letterId, letterType: letterType)
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
                    .onChange(of: showDetailLetter) { _, newValue in
                        if newValue {
                            offset = 0
                            showDeleteButton = false
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle(letterType.description)
        .toolbarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .fullScreenCover(isPresented: $showDetailLetter) {
            LetterContentView(letter: letter)
        }
    }
}
