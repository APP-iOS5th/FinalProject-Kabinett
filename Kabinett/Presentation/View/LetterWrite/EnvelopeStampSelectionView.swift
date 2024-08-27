//
//  EnvelopeSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/27/24.
//

import SwiftUI

struct EnvelopeStampSelectionView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    NavigationBarView(destination: WriteLetterView(letterContent: $letterContent), titleName: "봉투와 우표 고르기")
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ModalTestView()
}
