//
//  LetterBoxCell.swift
//  Kabinett
//
//  Created by uunwon on 8/14/24.
//

import SwiftUI

struct LetterBoxCell: View {
    var type: String = "All"
    var typeName: String = "전체 편지"
    
    var body: some View {
        VStack {
            ZStack {
                LetterBoxEnvelopeCell()
                
                Rectangle()
                    .fill(.clear)
                    .background(.clear.opacity(0.1))
                    .background(TransparentBlurView(removeAllFilters: true).blur(radius: 2))
                    .background(.ultraThinMaterial)
                    .frame(width: 125, height: 180)
                    .opacity(0.8)
                    .padding(.top, 31)
                    .shadow(radius: 1, y: CGFloat(2))
                    .blendMode(.luminosity)
                
                Text(type)
                    .font(.custom("Pecita", size: 20))
                    .offset(y: 90)
            }
            .padding(.bottom, 12)
            
            HStack {
                Text(typeName)
                    .font(.system(size: 11))
                    .foregroundStyle(.contentSecondary)
                
//                새로 도착한 편지에 대한 알림
//                ZStack {
//                    Circle()
//                        .fill(.red)
//                        .frame(width: 17)
//                    Text("1")
//                        .font(.system(size: 9))
//                        .foregroundStyle(.white)
//                }
//                .padding(.leading, -2)
            }
            
        }
        
        
    }
}

#Preview {
    LetterBoxCell()
}