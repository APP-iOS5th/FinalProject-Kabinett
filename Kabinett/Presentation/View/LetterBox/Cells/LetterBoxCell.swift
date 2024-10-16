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
                    let (xOffset, yOffset, rotation) = LayoutHelper.calculateOffsetAndRotation(for: index, totalCount: letters.count)
                    
                    SmallEnvelopeCell(letter: letter)
                        .offset(x: xOffset, y: yOffset)
                        .rotationEffect(.degrees(rotation))
                }
                .onAppear { }
                
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 2.1)
                    .frame(width: LayoutHelper.shared.getWidth(forSE: 0.32, forOthers: 0.35),
                           height: LayoutHelper.shared.getSize(forSE: 0.26, forOthers: 0.25))
                    .padding(.top, LayoutHelper.shared.getSize(forSE: 0.043, forOthers: 0.042))
                
                CustomStrokePathView()
                
                Text(type.description)
                    .font(.custom("Pecita", size: LayoutHelper.shared.getSize(forSE: 0.028, forOthers: 0.025)))
                    .offset(y: LayoutHelper.shared.getSize(forSE: 0.133, forOthers: 0.127))
            }
            .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.015, forOthers: 0.017))
            
            Spacer(minLength: 0)
            
            HStack {
                Text(type.koName())
                    .font(.system(size: LayoutHelper.shared.getSize(forSE: 0.018, forOthers: 0.015)))
                    .foregroundStyle(.contentSecondary)
                
                if unreadCount > 0 {
                    ZStack {
                        Image("RedSticker")
                            .resizable()
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.056, forOthers: 0.056),
                                   height: LayoutHelper.shared.getSize(forSE: 0.032, forOthers: 0.026))
                        
                        Text(unreadCount > 99 ? "99" : "\(unreadCount)")
                            .font(.system(size: LayoutHelper.shared.getSize(forSE: 0.017, forOthers: 0.016)))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.05, forOthers: 0.055),
                                   height: LayoutHelper.shared.getSize(forSE: 0.03, forOthers: 0.025),
                                   alignment: .center)
                    }

                    .padding(.leading, -LayoutHelper.shared.getWidth(forSE: 0.002, forOthers: 0.005))
                }
            }
        }
    }
}

#Preview {
    LetterBoxCell(viewModel: LetterBoxViewModel(letterBoxUseCase: LetterBoxUseCaseStub()), type: .all, unreadCount: 1)
}
