//
//  LetterBoxEnvelopeCell.swift
//  Kabinett
//
//  Created by uunwon on 8/12/24.
//

import SwiftUI
import Kingfisher

struct LetterBoxEnvelopeCell: View {
    var letter: Letter
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("보내는 사람")
                        .font(.system(size: 5))
                    Text(letter.fromUserName)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: 150, alignment: .leading)
                }
                
                KFImage(URL(string: letter.stampImageUrlString))
                    .placeholder {
                        Color.clear
                    }
                    .resizable()
                    .frame(width: 27, height: 30)
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.bottom, 15.0)
            
            HStack(alignment: .top) {
                Text(letter.postScript ?? "")
                    .font(.system(size: 7))
                    .frame(width: 110, alignment: .leading)
                    .padding(.top, -3.0)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("받는 사람")
                        .font(.system(size: 5))
                    Text(letter.toUserName)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: 60, alignment: .leading)
                }
            }
        }
        .padding(15)
        .background(Color.white)
        .border(.gray, width: 0.1)
        .rotationEffect(.degrees(270))
        .shadow(color: Color.primary300.opacity(0.7), radius: 5, x: CGFloat(5), y: CGFloat(5))
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
    LetterBoxEnvelopeCell(letter: LetterBoxViewModel.sampleLetters[0])
}
