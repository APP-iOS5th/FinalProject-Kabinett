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
                .background(.primary300.opacity(0.8))
                .background(.ultraThinMaterial)
                .frame(height: 45)
                .cornerRadius(30)
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 20)
            
            Text(message)
                .font(.system(size: 14))
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    ToastView(message: "편지가 도착했습니다.", horizontalPadding: 50)
}
