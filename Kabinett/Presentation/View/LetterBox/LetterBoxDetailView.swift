//
//  LetterBoxDetailView.swift
//  Kabinett
//
//  Created by uunwon on 8/14/24.
//

import SwiftUI

struct LetterBoxDetailView: View {
    @State var letterBoxType: String
    
    @Environment(\.dismiss) private var dismiss
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.system(size: 19, weight: .regular))
                    .padding(.leading, 4)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.background
            
        }
        .ignoresSafeArea()
        .navigationTitle(letterBoxType)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{} label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button{} label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                .padding(5)
            }
        }
    }
}

#Preview {
    LetterBoxDetailView(letterBoxType: "All")
}
