//
//  LetterBoxDetailView.swift
//  Kabinett
//
//  Created by uunwon on 8/14/24.
//

import SwiftUI

struct LetterBoxDetailView: View {
    @State var letterBoxType: String
    @State private var letterCount: Int = 0
    
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
            
            VStack {
                Spacer()
                
                ZStack {
                    Text("\(letterCount)")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 7)
                        .foregroundStyle(.black)
                        .background(.primary300.opacity(0.9))
                        .cornerRadius(20)
                        .padding()
                        .font(.system(size: 15, weight: .medium))
                }
                .padding(.bottom, 20)
            }
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
