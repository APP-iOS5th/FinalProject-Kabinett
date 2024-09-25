//
//  ToastView.swift
//  Kabinett
//
//  Created by uunwon on 8/17/24.
//

import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var showToast: Bool
    
    @State private var actualCurrentOffset: CGSize = CGSize(width: 0, height: UIScreen.main.bounds.height)
    
    var body: some View {
        if showToast {
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .background(.primary900)
                    .frame(height: 50)
                    .cornerRadius(28)
                    .padding(.horizontal, 50)
                
                Text(message)
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(.white)
            }
            .offset(y: actualCurrentOffset.height)
            .onAppear {
                withAnimation(.easeOut(duration: 1.2)) {
                    actualCurrentOffset = CGSize(width: 0, height: 0)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                    withAnimation(.easeInOut(duration: 1.3)) {
                        actualCurrentOffset = CGSize(width: 0, height: UIScreen.main.bounds.height)
                        showToast = false
                    }
                }
            }
            .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.01, forOthers: 0.01))
        }
    }
}

#Preview {
    ToastView(message: "카비넷 팀이 보낸 편지가 도착했어요.", showToast: .constant(true))
}
