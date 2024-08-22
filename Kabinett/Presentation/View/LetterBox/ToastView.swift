//
//  ToastView.swift
//  Kabinett
//
//  Created by uunwon on 8/17/24.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let horizontalPadding: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .background(.primary900)
                .frame(height: 50)
                .cornerRadius(28)
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 20)
            
            Text(message)
                .font(.system(size: 16, weight: .heavy))
                .foregroundStyle(.white)
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    ToastView(message: "편지가 도착했어요.", horizontalPadding: 40)
}
