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
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.002 * 1.1, forOthers: 0.002 * 1.1)) {
                            Text("보내는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.009 * 1.1, forOthers: 0.008 * 1.1)))
                                .foregroundStyle(.contentPrimary)
                            Text(letter.fromUserName)
                                .font(FontUtility.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.018 * 1.1, forOthers: 0.017 * 1.1)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.57 * 1.1, forOthers: 0.57 * 1.1), alignment: .leading)
                        }
                        
                        KFImage(URL(string: letter.stampImageUrlString))
                            .placeholder {
                                Color.clear
                            }
                            .resizable()
                            .frame(
                                width: LayoutHelper.shared.getWidth(forSE: 0.09 * 1.1, forOthers: 0.09 * 1.1),
                                height: LayoutHelper.shared.getSize(forSE: 0.053 * 1.1, forOthers: 0.046 * 1.1)
                            )
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.035 * 1.1, forOthers: 0.03 * 1.1))
                    
                    HStack(alignment: .top) {
                        Text(letter.postScript ?? "")
                            .font(FontUtility.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.012 * 1.1, forOthers: 0.012 * 1.1)))
                            .foregroundStyle(.contentPrimary)
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.4 * 1.1, forOthers: 0.4 * 1.1), alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.002 * 1.1, forOthers: 0.002 * 1.1)) {
                            Text("받는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.008 * 1.1, forOthers: 0.008 * 1.1)))
                                .foregroundStyle(.contentPrimary)
                            Text(letter.toUserName)
                                .font(FontUtility.selectedFont(font: letter.fontString ?? "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.017 * 1.1, forOthers: 0.017 * 1.1)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.26 * 1.1, forOthers: 0.26 * 1.1), alignment: .leading)
                        }
                    }
                }
            }
            .frame(
                width: LayoutHelper.shared.getWidth(forSE: 0.8 * 1.1, forOthers: 0.8 * 1.1),
                height: LayoutHelper.shared.getSize(forSE: 0.2 * 1.1, forOthers: 0.17 * 1.1)
            )
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
