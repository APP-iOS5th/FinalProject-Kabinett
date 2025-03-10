//
//  WidgetEnvelopeView.swift
//  KabinettWidgetExtension
//
//  Created by Jihye Seok on 3/6/25.
//

import SwiftUI
import Kingfisher

struct WidgetEnvelopeView: View {
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.00162, forOthers: 0.00162)) {
                            Text("보내는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.00729, forOthers: 0.00648)))
                                .foregroundStyle(.contentPrimary)
                            Text("보내는사람아ㅔ게")
                                .font(FontUtility.selectedFont(font: "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.01458, forOthers: 0.01377)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.4617, forOthers: 0.4617), alignment: .leading)
                        }
                        
                        KFImage(URL(string: "https://firebasestorage.googleapis.com/v0/b/kabinett-2b247.appspot.com/o/Stamps%2FStamp0.png?alt=media&token=b7cea6b3-a317-4695-b1b3-d71c68a9717f"))
                            .placeholder {
                                Color.clear
                            }
                            .resizable()
                            .frame(
                                width: LayoutHelper.shared.getWidth(forSE: 0.0729, forOthers: 0.0729),
                                height: LayoutHelper.shared.getSize(forSE: 0.04293, forOthers: 0.03726)
                            )
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.02835, forOthers: 0.0243))
                    
                    HStack(alignment: .top) {
                        Text("추신수입니다!")
                            .font(FontUtility.selectedFont(font: "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.00972, forOthers: 0.00972)))
                            .foregroundStyle(.contentPrimary)
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.324, forOthers: 0.324), alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.00162, forOthers: 0.00162)) {
                            Text("받는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.00648, forOthers: 0.00648)))
                                .foregroundStyle(.contentPrimary)
                            Text("YULE")
                                .font(FontUtility.selectedFont(font: "Pecita", size: LayoutHelper.shared.getSize(forSE: 0.01377, forOthers: 0.01377)))
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
                        KFImage(URL(string: "https://firebasestorage.googleapis.com/v0/b/kabinett-2b247.appspot.com/o/Envelopes%2FEnvelope0.png?alt=media&token=2a6e0dc3-8ed1-467d-a953-8297975a8334"))
                            .resizable()
                    )
                    .shadow(color: .primary300, radius: 4, x: 5, y: 5)
            )
            .padding(.trailing, LayoutHelper.shared.getSize(forSE: 0.006, forOthers: 0.008))
        }
    }
}
