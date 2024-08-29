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
                        .font(.custom("SFDisplay", size: 5))
                        .foregroundStyle(.contentPrimary)
                    Text(letter.fromUserName)
                        .font(.custom(letter.fontString ?? "SFDisplay", size: 10))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: 150, alignment: .leading)
                }
                
                KFImage(URL(string: letter.stampImageUrlString))
                    .placeholder {
                        Color.clear
                    }
                    .resizable()
                    .frame(width: 27.63, height: 30.18)
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.bottom, 15.0)
            
            HStack(alignment: .top) {
                Text(letter.postScript ?? "")
                    .font(.custom(letter.fontString ?? "SFDisplay", size: 7))
                    .frame(width: 117, alignment: .leading)
                    .foregroundStyle(.contentPrimary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("받는 사람")
                        .font(.custom("SFDisplay", size: 5))
                        .foregroundStyle(.contentPrimary)
                    Text(letter.toUserName)
                        .font(.custom(letter.fontString ?? "SFDisplay", size: 10))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: 60, alignment: .leading)
                        .padding(.bottom, 5.0)
                }
            }
        }
        .padding(15)
        .background(Color.white)
        .rotationEffect(.degrees(270))
        .shadow(color: Color.primary300.opacity(0.7), radius: 5, x: CGFloat(5), y: CGFloat(5))
    }
}

struct LetterBoxDetailEnvelopeCell: View {
    var letter: Letter
    
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("보내는 사람")
                                .font(.custom("SFDisplay", size: 7))
                                .foregroundStyle(.contentPrimary)
                            Text(letter.fromUserName)
                                .font(.custom(letter.fontString ?? "SFDisplay", size: 14))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: 210, alignment: .leading)
                        }
                        
                        KFImage(URL(string: letter.stampImageUrlString))
                            .placeholder {
                                Color.clear
                            }
                            .resizable()
                            .frame(width: 34.96, height: 38.18)
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.bottom, 26.0)
                    
                    HStack(alignment: .top) {
                        Text(letter.postScript ?? "")
                            .font(.custom(letter.fontString ?? "SFDisplay", size: 10))
                            .foregroundStyle(.contentPrimary)
                            .frame(width: 163, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("받는 사람")
                                .font(.custom("SFDisplay", size: 7))
                                .foregroundStyle(.contentPrimary)
                            Text(letter.toUserName)
                                .font(.custom(letter.fontString ?? "SFDisplay", size: 14))
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
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 5, y: 5)
            )
    
            // 새로운 편지에 붙을 빨간 동그라미
            if !letter.isRead {
                Image("RedSticker")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.leading, 300)
                    .padding(.bottom, 113)
            }
        }
    }
}

#Preview {
//    LetterBoxEnvelopeCell(letter: LetterBoxUseCaseStub.sampleLetters[0])
    LetterBoxDetailEnvelopeCell(letter: LetterBoxUseCaseStub.sampleLetters[0])
}
