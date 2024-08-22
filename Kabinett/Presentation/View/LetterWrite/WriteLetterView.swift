//
//  WirteLetter.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import SwiftUI

struct WriteLetterView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationBarView(destination: WriteLetterView(letterContent: $letterContent), titleName: "편지 쓰기")
    }
}

#Preview {
    ModalTestView()
}
