//
//  WriteLetterEnvelopeCell.swift
//  Kabinett
//
//  Created by Song Kim on 11/11/24.
//

import SwiftUI
import Kingfisher

struct WriteLetterEnvelopeCell: View {
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
                                .font(FontUtility.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.018, forOthers: 0.017)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.62, forOthers: 0.62), alignment: .leading)
                        }
                        
                        KFImage(URL(string: letter.stampImageUrlString))
                            .placeholder {
                                Color.clear
                            }
                            .resizable()
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.1, forOthers: 0.1), height: LayoutHelper.shared.getSize(forSE: 0.06, forOthers: 0.052))
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.035, forOthers: 0.03))
                    
                    HStack(alignment: .top) {
                        Text(letter.postScript ?? "")
                            .font(FontUtility.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.012, forOthers: 0.012)))
                            .foregroundStyle(.contentPrimary)
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.44, forOthers: 0.44), alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.002, forOthers: 0.002)) {
                            Text("받는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.008, forOthers: 0.008)))
                                .foregroundStyle(.contentPrimary)
                            Text(letter.toUserName)
                                .font(FontUtility.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.017, forOthers: 0.017)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.29, forOthers: 0.29), alignment: .leading)
                        }
                    }
                }
            }
            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.88, forOthers: 0.88), height: LayoutHelper.shared.getSize(forSE: 0.22, forOthers: 0.19))
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.clear)
                    .background(
                        KFImage(URL(string: letter.envelopeImageUrlString))
                            .resizable()
                    )
                    .shadow(color: .primary300, radius: 4, x: 0, y: 0)
            )
        }
    }
}
