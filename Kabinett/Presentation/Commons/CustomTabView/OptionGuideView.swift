//
//  OptionGuideView.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 12/17/24.
//

import SwiftUI

struct OptionGuideView: View {
    var body: some View {
        HStack(spacing: 0) {
            OptionOverlayGuide(
                text: "간직하고 있던 편지를 촬영해 보관해요.",
                boldText: "촬영",
                position: .left,
                isVisible: true
            )
            .frame(width: UIScreen.main.bounds.width/2)
            
            OptionOverlayGuide(
                text: "카비넷 사용자라면 \n이름이나 번호를 검색해 \n편지를 보낼 수 있어요.",
                boldText: "이름이나 번호",
                position: .right,
                isVisible: true
            )
            .frame(width: UIScreen.main.bounds.width/2)
        }
        .padding(.bottom, 16)
    }
}
