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
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.002, forOthers: 0.002)) {
                            Text("보내는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.008, forOthers: 0.008)))
                                .foregroundStyle(.contentPrimary)
                            Text("보내는 사람에게")
                                .font(FontUtility.selectedFont(font: "Pecita", size: LayoutHelper.shared.getSize(forSE: 0.015, forOthers: 0.015)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.57, forOthers: 0.57), alignment: .leading)
                        }
                        
                        KFImage(URL(string: "https://firebasestorage.googleapis.com/v0/b/kabinett-2b247.appspot.com/o/Stamps%2FStamp0.png?alt=media&token=b7cea6b3-a317-4695-b1b3-d71c68a9717f"))
                            .placeholder {
                                Color.clear
                            }
                            .resizable()
                            .frame(
                                width: LayoutHelper.shared.getWidth(forSE: 0.09, forOthers: 0.09),
                                height: LayoutHelper.shared.getSize(forSE: 0.053, forOthers: 0.046)
                            )
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.035, forOthers: 0.03))
                    
                    HStack(alignment: .top) {
                        Text("추신수입니다!")
                            .font(FontUtility.selectedFont(font: "SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.012, forOthers: 0.012)))
                            .foregroundStyle(.contentPrimary)
                            .frame(width: LayoutHelper.shared.getWidth(forSE: 0.4, forOthers: 0.4), alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: LayoutHelper.shared.getSize(forSE: 0.002, forOthers: 0.002)) {
                            Text("받는 사람")
                                .font(.custom("SFDisplay", size: LayoutHelper.shared.getSize(forSE: 0.008, forOthers: 0.008)))
                                .foregroundStyle(.contentPrimary)
                            Text("YULE")
                                .font(FontUtility.selectedFont(font: "Pecita", size: LayoutHelper.shared.getSize(forSE: 0.015, forOthers: 0.015)))
                                .foregroundStyle(.contentPrimary)
                                .frame(maxWidth: LayoutHelper.shared.getWidth(forSE: 0.26, forOthers: 0.26), alignment: .leading)
                        }
                    }
                }
            }
            .frame(
                width: LayoutHelper.shared.getWidth(forSE: 0.6, forOthers: 0.6),
                height: LayoutHelper.shared.getSize(forSE: 0.15, forOthers: 0.12)
            )
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.clear)
                    .background(
                        KFImage(URL(string: "https://firebasestorage.googleapis.com/v0/b/kabinett-2b247.appspot.com/o/Envelopes%2FEnvelope0.png?alt=media&token=2a6e0dc3-8ed1-467d-a953-8297975a8334")!)
                            .resizable()
                    )
                    .shadow(color: .primary300, radius: 4, x: 0, y: 0)
            )
        }
    }
}
