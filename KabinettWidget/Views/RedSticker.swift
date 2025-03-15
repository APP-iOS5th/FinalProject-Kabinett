//
//  RedSticker.swift
//  KabinettWidgetExtension
//
//  Created by Jihye Seok on 3/10/25.
//

import SwiftUI

struct RedSticker: View {
    var body: some View {
        ZStack {
            
            Image("RedSticker")
                .resizable()
            Text("1")
                .font(.system(size: LayoutHelper.shared.getSize(forSE: 0.02, forOthers: 0.019)))
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
        .frame(width: LayoutHelper.shared.getWidth(forSE: 0.063, forOthers: 0.066), height: LayoutHelper.shared.getSize(forSE: 0.035, forOthers: 0.031))
        .padding(.leading, LayoutHelper.shared.getWidth(forSE: 0.729, forOthers: 0.72))
        .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.139, forOthers: 0.118))
    }
}
