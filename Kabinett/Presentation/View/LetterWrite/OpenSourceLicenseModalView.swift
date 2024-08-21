//
//  OpenSourceLicenseView.swift
//  Kabinett
//
//  Created by Song Kim on 8/21/24.
//

import SwiftUI

struct OpenSourceLicenseModalView: View {
    var body: some View {
        ZStack {
            Color("Primary100").ignoresSafeArea()

            VStack {
                Text("내장되어 있는 모든 폰트는 SIL Open Font License version 1.1에 따라 사용하고 있습니다. 각 폰트의 저작권은 해당 디자이너에게 있습니다.")
                    .font(.system(size: 11, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding([.leading, .trailing], 30)
                    .padding([.top, .bottom], 20)
                
                Text("""
             네이버 나눔 명조 - 네이버
             구름 산스 코드 - 구름
             Pecita -  Philippe Cochy
             Source Han Serif 본명조 - Adobe
             Baskerville - Thomas Huot-Marchand
            """)
                .font(.system(size: 11.5, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding([.leading, .trailing, .bottom], 40)
            }
        }
    }
}
