//
//  LetterBoxCell.swift
//  Kabinett
//
//  Created by uunwon on 8/14/24.
//

import SwiftUI

struct LetterBoxCell: View {
    @EnvironmentObject var viewModel: LetterBoxViewModel
    
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
                    .frame(width: viewModel.getWidth(forSE: 0.33, forOthers: 0.36), height: viewModel.getSize(forSE: 0.27, forOthers: 0.252))
//                    .background(.ultraThinMaterial)
                    .padding(.top, viewModel.getSize(forSE: 0.042, forOthers: 0.042))
//                    .opacity(0.5)
                    .shadow(radius: 1, y: CGFloat(2))
                    .blendMode(.luminosity)
                
                Text(type.description)
                    .font(.custom("Pecita", size: viewModel.getSize(forSE: 0.028, forOthers: 0.025)))
                    .offset(y: viewModel.getSize(forSE: 0.133, forOthers: 0.127))
            }
            .padding(.bottom, viewModel.getSize(forSE: 0.015, forOthers: 0.017))
            
            Spacer(minLength: 0)
            
            HStack {
                Text(type.koName())
                    .font(.system(size: viewModel.getSize(forSE: 0.019, forOthers: 0.016)))
                    .foregroundStyle(.contentSecondary)
                
//                새로 도착한 편지에 대한 알림
                if unreadCount > 0 {
                    ZStack {
                        Image("RedSticker")
                            .resizable()
                            .frame(width: viewModel.getWidth(forSE: 0.056, forOthers: 0.056), height: viewModel.getSize(forSE: 0.032, forOthers: 0.026))
                        Text("\(unreadCount)")
                            .font(.system(size: viewModel.getSize(forSE: 0.019, forOthers: 0.017)))
                            .foregroundStyle(.white)
                    }
                    .padding(.leading, -viewModel.getWidth(forSE: 0.002, forOthers: 0.005))
                }
            }
        }
    }
}

#Preview {
    LetterBoxCell(type: .all, unreadCount: 1)
        .environmentObject(LetterBoxViewModel(letterBoxUseCase: LetterBoxUseCaseStub()))
}
