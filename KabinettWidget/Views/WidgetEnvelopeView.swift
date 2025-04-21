//
//  WidgetEnvelopeView.swift
//  KabinettWidgetExtension
//
//  Created by Jihye Seok on 3/6/25.
//

import SwiftUI
import Kingfisher

struct WidgetEnvelopeView: View {
    let letter: WidgetLetter
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.00162, forOthers: 0.00162)) {
                            Text("보내는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.00729, forOthers: 0.00648)))
                                .foregroundStyle(.contentPrimary)
                            Text(letter.fromUserName)
                                .font(FontUtility.selectedFont(font: letter.fontString, size: LayoutHelper.shared.getSize(forSE: 0.01458, forOthers: 0.01377)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.4617, forOthers: 0.4617), alignment: .leading)
                        }
                        
                        KFImage(URL(string: letter.stampImageUrlString))
                            .placeholder {
                                Color.clear
                            }
                            .resizable()
                            .frame(
                                width: LayoutHelper.shared.getWidth(forSE: 0.0729, forOthers: 0.0729),
                                height: LayoutHelper.shared.getSize(forSE: 0.04293, forOthers: 0.03726)
                            )
                            .offset(x: 3)
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.03969, forOthers: 0.03645))
                    
                    HStack(alignment: .top) {
                        Text(letter.postScript)
                            .font(FontUtility.selectedFont(font: "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.0106, forOthers: 0.0106)))
                            .foregroundStyle(.contentPrimary)
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.324, forOthers: 0.324), alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.00162, forOthers: 0.00162)) {
                            Text("받는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.00729, forOthers: 0.00648)))
                                .foregroundStyle(.contentPrimary)
                            Text(letter.toUserName)
                                .font(FontUtility.selectedFont(font: letter.fontString, size: LayoutHelper.shared.getSize(forSE: 0.01458, forOthers: 0.01377)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.2106, forOthers: 0.2106), alignment: .leading)
                        }
                    }
                }
            }
            .frame(
                width: LayoutHelper.shared.getWidth(forSE: 0.648, forOthers: 0.648),
                height: LayoutHelper.shared.getSize(forSE: 0.162, forOthers: 0.1377)
            )
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.clear)
                    .background(
                        KFImage(URL(string: letter.envelopeImageUrlString))
                            .resizable()
                    )
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 5, y: 5)
            )
            .padding(.trailing, LayoutHelper.shared.getSize(forSE: 0.006, forOthers: 0.008))
        }
    }
}
