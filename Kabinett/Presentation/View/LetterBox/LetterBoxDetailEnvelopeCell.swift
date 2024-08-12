//
//  LetterBoxDetailEnvelopeCell.swift
//  Kabinett
//
//  Created by uunwon on 8/12/24.
//

import SwiftUI

struct LetterBoxDetailEnvelopeCell: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("보내는 사람")
                        .font(.system(size: 9))
                    Text("Dotorie")
                        .font(.system(size: 22, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "rectangle.portrait.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
            }
            .padding(.bottom, 40.0)
            
            HStack(alignment: .top) {
                Text("사진 몇 장 같이 넣어뒀어!")
                    .font(.system(size: 12))
                    .frame(width: 220, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("받는 사람")
                        .font(.system(size: 9))
                    Text("Yule")
                        .font(.system(size: 22, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
        }
        .padding(25)
    }
}

#Preview {
    LetterBoxDetailEnvelopeCell()
}
