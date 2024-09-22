//
//  SmallEnvelopeCell.swift
//  Kabinett
//
//  Created by uunwon on 8/12/24.
//

import SwiftUI
import Kingfisher

struct SmallEnvelopeCell: View {
    @EnvironmentObject var fontViewModel: FontSelectionViewModel
    var letter: Letter
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.003, forOthers: 0.003)) {
                    Text("보내는 사람")
                        .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.006, forOthers: 0.006)))
                        .foregroundStyle(.contentPrimary)
                    Text(letter.fromUserName)
                        .font(fontViewModel.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.0122, forOthers: 0.0122)))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.4, forOthers: 0.443), alignment: .leading)
                }
                
                KFImage(URL(string: letter.stampImageUrlString))
                    .placeholder {
                        Color.clear
                    }
                    .resizable()
                    .frame(width: LayoutHelper.shared.getWidth(forSE: 0.059, forOthers: 0.069), height: LayoutHelper.shared.getSize(forSE: 0.038, forOthers: 0.036))
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.029, forOthers: 0.025))
            
            HStack(alignment: .top) {
                Text(letter.postScript ?? "")
                    .font(.custom(letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.008, forOthers: 0.008)))
                    .frame(width: LayoutHelper.shared.getWidth(forSE: 0.29, forOthers: 0.32), alignment: .leading)
                    .foregroundStyle(.contentPrimary)
                
                VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.002, forOthers: 0.002)) {
                    Text("받는 사람")
                        .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.006, forOthers: 0.006)))
                        .foregroundStyle(.contentPrimary)
                    Text(letter.toUserName)
                        .font(fontViewModel.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.0122, forOthers: 0.0122)))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.17, forOthers: 0.2), alignment: .leading)
                        .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.008, forOthers: 0.008))
                }
            }
        }
        .frame(width: LayoutHelper.shared.getWidth(forSE: 0.55, forOthers: 0.63), height: LayoutHelper.shared.getSize(forSE: 0.148, forOthers: 0.134))
        .background(
            KFImage(URL(string: letter.envelopeImageUrlString))
                .resizable()
        )
        .rotationEffect(.degrees(270))
        .shadow(color: .primary300, radius: 5, x: 3, y: 3)
    }
}

struct LargeEnvelopeCell: View {
    @EnvironmentObject var fontViewModel: FontSelectionViewModel
    var letter: Letter
    
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.002, forOthers: 0.002)) {
                            Text("보내는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.009, forOthers: 0.008)))
                                .foregroundStyle(.contentPrimary)
                            Text(letter.fromUserName)
                                .font(fontViewModel.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.018, forOthers: 0.017)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.57, forOthers: 0.57), alignment: .leading)
                        }
                        
                        KFImage(URL(string: letter.stampImageUrlString))
                            .placeholder {
                                Color.clear
                            }
                            .resizable()
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.09, forOthers: 0.09), height: LayoutHelper.shared.getSize(forSE: 0.053, forOthers: 0.046))
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.035, forOthers: 0.03))
                    
                    HStack(alignment: .top) {
                        Text(letter.postScript ?? "")
                            .font(fontViewModel.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.012, forOthers: 0.012)))
                            .foregroundStyle(.contentPrimary)
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.4, forOthers: 0.4), alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.002, forOthers: 0.002)) {
                            Text("받는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.008, forOthers: 0.008)))
                                .foregroundStyle(.contentPrimary)
                            Text(letter.toUserName)
                                .font(fontViewModel.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.017, forOthers: 0.017)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.26, forOthers: 0.26), alignment: .leading)
                        }
                    }
                }
            }
            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.8, forOthers: 0.8), height: LayoutHelper.shared.getSize(forSE: 0.2, forOthers: 0.17))
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.clear)
                    .background(
                        KFImage(URL(string: letter.envelopeImageUrlString))
                            .resizable()
                    )
                    .shadow(color: .primary300, radius: 4, x: 0, y: 0)
            )
    
            if !letter.isRead {
                Image("RedSticker")
                    .resizable()
                    .frame(width: LayoutHelper.shared.getWidth(forSE: 0.063, forOthers: 0.066), height: LayoutHelper.shared.getSize(forSE: 0.035, forOthers: 0.031))
                    .padding(.leading, LayoutHelper.shared.getWidth(forSE: 0.81, forOthers: 0.8))
                    .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.155, forOthers: 0.132))
            }
        }
    }
}

#Preview {
//    SmallEnvelopeCell(letter: LetterBoxUseCaseStub.sampleSearchOfDateLetters[0])
    LargeEnvelopeCell(letter: LetterBoxUseCaseStub.sampleSearchOfDateLetters[0])
}
