//
//  LetterBoxCell.swift
//  Kabinett
//
//  Created by uunwon on 8/14/24.
//

import SwiftUI

struct LetterBoxCell: View {
    @ObservedObject var letterBoxViewModel: LetterBoxViewModel
    
    var type: LetterType
    var unreadCount: Int
    
    private var letters: [Letter] {
        return letterBoxViewModel.getSomeLetters(for: type)
    }
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(Array(letters.reversed().enumerated()), id: \.element.id) { index, letter in
                    let (xOffset, yOffset, rotation) = calculateOffsetAndRotation(for: index, totalCount: letters.count)
                    
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
    
    func calculateOffsetAndRotation(for index: Int, totalCount: Int) -> (xOffset: CGFloat, yOffset: CGFloat, rotation: Double) {
        switch totalCount {
        case 1:
            return (xOffset: CGFloat(-6.5), yOffset: CGFloat(-1.5), rotation: Double(-1.5))
        case 2:
            let xOffset = index == 0 ? -7 : 6
            let yOffset = index == 0 ? -10 : -2
            let rotation = index == 0 ? -1 : 0
            return (xOffset: CGFloat(xOffset), yOffset: CGFloat(yOffset), rotation: Double(rotation))
        case 3:
            let xOffset = [-12, -5, 12][index]
            let yOffset = [-3, -12, -2][index]
            return (xOffset: CGFloat(xOffset), yOffset: CGFloat(yOffset), rotation: 0)
        default:
            return (xOffset: 0, yOffset: 0, rotation: 0)
        }
    }
}

#Preview {
    LetterBoxCell(letterBoxViewModel: LetterBoxViewModel(), type: .all, unreadCount: 1)
}
