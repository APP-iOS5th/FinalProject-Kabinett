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
            Image("LetterImportGuide")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width/2 - 8)
            
            Image("LetterWriteGuide")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width/2 - 8)
        }
    }
}
