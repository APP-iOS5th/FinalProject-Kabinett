//
//  LetterBoxEnvelopeCell.swift
//  Kabinett
//
//  Created by uunwon on 8/12/24.
//

import SwiftUI

struct LetterBoxEnvelopeCell: View {
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 2) {
                VStack(alignment: .leading) {
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
            
            HStack(alignment: .top, spacing: 2) {
                Text("사진 몇 장 같이 넣어뒀어!")
                    .font(.system(size: 12))
                    .frame(width: 220, alignment: .leading)
                    .padding(.top, -5.0)
                
                VStack(alignment: .leading) {
                    Text("받는 사람")
                        .font(.system(size: 9))
                    Text("Yule")
                        .font(.system(size: 22, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
        }
        .padding(28)
    }
}

#Preview {
    LetterBoxEnvelopeCell()
}
