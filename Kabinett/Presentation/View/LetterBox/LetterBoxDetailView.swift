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
    
    let letters = Array(0...10) // dummy
//    let letters: [Int] = [] // empty dummy
    
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
            
            ZStack {
                if letters.count == 0 {
                    Text("아직 나에게 보낸 편지가 없어요.")
                        .font(.system(size: 16, weight: .semibold))
                }
                else if letters.count < 3 {
                    VStack(spacing: 25) {
                        ForEach(letters, id: \.self) { letter in
                            LetterBoxDetailEnvelopeCell()
                        }
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: -75) {
                            ForEach(letters.indices, id: \.self) { idx in
                                if idx < 2 {
                                    LetterBoxDetailEnvelopeCell()
                                        .padding(.bottom, idx == 0 ? 80 : 37)
                                } else {
                                    LetterBoxDetailEnvelopeCell()
                                        .zIndex(Double(idx))
                                        .padding(.bottom, idx % 3 == 1 ? 37 : 0)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                letterCount = letters.count
            }
            
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
