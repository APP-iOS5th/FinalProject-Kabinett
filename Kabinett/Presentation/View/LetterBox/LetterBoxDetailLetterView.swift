//
//  LetterBoxDetailLetterView.swift
//  Kabinett
//
//  Created by uunwon on 8/28/24.
//

import SwiftUI

struct LetterBoxDetailLetterView: View {
    var letter: Letter
    
    var body: some View {
        LetterBoxDetailEnvelopeCell(letter: letter)
    }
}

#Preview {
    LetterBoxDetailLetterView(letter: LetterBoxUseCaseStub.sampleSearchOfKeywordLetters[0])
}
