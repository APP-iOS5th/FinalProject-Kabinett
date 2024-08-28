//
//  LetterBoxCell.swift
//  Kabinett
//
//  Created by uunwon on 8/14/24.
//

import SwiftUI

struct LetterBoxCell: View {
    @ObservedObject var viewModel: LetterBoxViewModel
    
    var type: LetterType
    var unreadCount: Int
    
    private var letters: [Letter] {
        return viewModel.getSomeLetters(for: type)
    }
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(Array(letters.reversed().enumerated()), id: \.element.id) { index, letter in
                    let (xOffset, yOffset, rotation) = viewModel.calculateOffsetAndRotation(for: index, totalCount: letters.count)
                    
                    LetterBoxEnvelopeCell(letter: letter)
                        .offset(x: xOffset, y: yOffset)
                        .rotationEffect(.degrees(rotation))
                }
                .onAppear { }
                
                Rectangle()
                    .fill(.clear)
                    .background(.clear.opacity(0.1))
                    .background(TransparentBlurView(removeAllFilters: true).blur(radius: 0.8))
//                    .background(.ultraThinMaterial)
                    .frame(width: 135, height: 185)
//                    .opacity(0.5)
                    .padding(.top, 34)
                    .shadow(radius: 1, y: CGFloat(2))
                    .blendMode(.luminosity)
                
                Text(type.description)
                    .font(.custom("Pecita", size: 20))
                    .offset(y: 90)
            }
            .padding(.bottom, 13)
            
            Spacer(minLength: 0)
            
            HStack {
                Text(type.koName())
                    .font(.system(size: 11))
                    .foregroundStyle(.contentSecondary)
                
//                새로 도착한 편지에 대한 알림
                if unreadCount > 0 {
                    ZStack {
                        Image("RedSticker")
                            .resizable()
                            .frame(width: 22, height: 22)
                        Text("\(unreadCount)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .padding(.leading, -2)
                }
            }
        }
    }
}

#Preview {
    LetterBoxCell(viewModel: LetterBoxViewModel(), type: .all, unreadCount: 1)
}
