//
//  WriteLetterView.swift
//  Kabinett
//
//  Created by Song Kim on 8/21/24.
//

import SwiftUI

struct WriteLetterView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .leading) {
                NavigationBarView(destination: ModalTestView(), titleName: "")
            }
            
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
}
