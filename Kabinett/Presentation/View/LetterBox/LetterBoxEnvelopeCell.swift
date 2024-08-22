//
//  LetterBoxEnvelopeCell.swift
//  Kabinett
//
//  Created by uunwon on 8/12/24.
//

import SwiftUI

struct LetterBoxEnvelopeCell: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("보내는 사람")
                        .font(.system(size: 6))
                    Text("Dotorie")
                        .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: 150, alignment: .leading)
                }
                
                Image(systemName: "rectangle.portrait.fill")
                    .resizable()
                    .foregroundStyle(.green)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
            }
            .padding(.bottom, 15.0)
            
            HStack(alignment: .top) {
                Text("사진 몇 장 같이 넣어뒀어!")
                    .font(.system(size: 7))
                    .frame(width: 110, alignment: .leading)
                    .padding(.top, -3.0)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("받는 사람")
                        .font(.system(size: 6))
                    Text("Yule")
                        .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: 60, alignment: .leading)
                }
            }
        }
        .padding(15)
        .background(Color.white)
        .border(.gray, width: 0.1)
        .rotationEffect(.degrees(270))
        .shadow(radius: 5, x: CGFloat(5), y: CGFloat(5))
    }
}

struct LetterBoxDetailEnvelopeCell: View {
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("보내는 사람")
                                .font(.system(size: 6))
                                .foregroundStyle(.contentPrimary)
                            Text("Dotorie")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: 210, alignment: .leading)
                        }
                        
                        Image(systemName: "rectangle.portrait.fill")
                            .resizable()
                            .foregroundStyle(.green)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33)
                    }
                    .padding(.bottom, 20.0)
                    
                    HStack(alignment: .top) {
                        Text("사진 몇 장 같이 넣어뒀어!")
                            .font(.system(size: 10))
                            .foregroundStyle(.contentPrimary)
                            .frame(width: 163, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("받는 사람")
                                .font(.system(size: 6))
                                .foregroundStyle(.contentPrimary)
                            Text("Yule")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: 80, alignment: .leading)
                        }
                    }
                }
                .padding(23)
                .border(.gray, width: 0.1)
            }
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.3), radius: 4, x: 5, y: 5)
            )
    
            // 새로운 편지에 붙을 빨간 동그라미
//            Circle()
//                .fill(.alert)
//                .frame(width: 25)
//                .padding(.leading, 300)
//                .padding(.bottom, 110)
        }
    }
}

#Preview {
    LetterBoxDetailEnvelopeCell()
}
