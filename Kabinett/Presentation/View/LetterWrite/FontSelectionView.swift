//
//  FontSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/17/24.
//

import SwiftUI

struct FontSelectionView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("폰트 고르기")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button (action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("ContentPrimary"))
                }
                .padding(.leading, 8)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("완료") {
                    
                }
                .foregroundStyle(Color.black)
                .padding(.trailing, 8)
            }
        }
        .toolbarBackground(Color("Background"), for: .navigationBar)
    }
}
