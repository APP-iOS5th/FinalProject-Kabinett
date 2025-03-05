//
//  ToastView.swift
//  Kabinett
//
//  Created by uunwon on 8/17/24.
//

import SwiftUI

struct ToastView: View {
    @ObservedObject var toastViewModel: ToastViewModel
    @State private var actualCurrentOffset: CGSize = CGSize(width: 0, height: UIScreen.main.bounds.height)
    
    var body: some View {
        if toastViewModel.showToast {
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .background(toastViewModel.backgroundColor)
                    .frame(height: 50)
                    .cornerRadius(28)
                    .padding(.horizontal, 50)
                
                Text(toastViewModel.message)
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(.white)
            }
            .offset(y: actualCurrentOffset.height)
            .onAppear {
                withAnimation(.easeOut(duration: 1)) {
                    actualCurrentOffset = CGSize(width: 0, height: 0)
                } completion: {
                    withAnimation(Animation.easeInOut(duration: 1.5).delay(1.2)) {
                        actualCurrentOffset = CGSize(width: 0, height: UIScreen.main.bounds.height)
                        toastViewModel.showToast = false
                    }
                }
            }
            .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.01, forOthers: 0.01))
        }
    }
}
