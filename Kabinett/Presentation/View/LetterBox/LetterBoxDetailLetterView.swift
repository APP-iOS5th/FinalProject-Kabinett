//
//  LetterBoxDetailLetterView.swift
//  Kabinett
//
//  Created by uunwon on 8/28/24.
//

import SwiftUI

struct LetterBoxDetailLetterView: View {
    @StateObject var viewModel = LetterViewModel()
    @State private var showDetailLetter = false
    
    var letterType: LetterType
    var letter: Letter
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            
            LetterBoxDetailEnvelopeCell(letter: letter)
                .onTapGesture {
                    if !letter.isRead {
                        guard let letterId = letter.id else {
                            return
                        }
                        viewModel.updateLetterReadStatus(letterId: letterId, letterType: letterType)
                        showDetailLetter = true
                    }
                }
        }
        .navigationTitle(letterType.description)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView(action: { dismiss() }))
    }
}

#Preview {
    LetterBoxDetailLetterView(letterType: .all, letter: LetterBoxUseCaseStub.sampleSearchOfKeywordLetters[0])
}
