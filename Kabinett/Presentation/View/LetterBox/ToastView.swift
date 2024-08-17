//
//  ToastView.swift
//  Kabinett
//
//  Created by uunwon on 8/17/24.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .background(.ultraThinMaterial)
                .frame(height: 42)
                .cornerRadius(30)
                .padding(.horizontal, 50)
                .padding(.bottom, 20)
            
            Text(message)
                .font(.system(size: 14))
                .padding(13)
                .frame(maxWidth: .infinity)
                .background(.primary300.opacity(0.8))
                .foregroundStyle(Color.black)
                .cornerRadius(30)
                .padding(.horizontal, 50)
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    ToastView(message: "편지가 도착했습니다.")
}
