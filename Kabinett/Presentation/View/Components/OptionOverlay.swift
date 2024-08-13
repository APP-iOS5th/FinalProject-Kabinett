//
//  OptionOverlay.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI

struct OptionOverlay: View {
    @Binding var showOptions: Bool
    @Binding var showActionSheet: Bool
    
    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation{
                    showOptions = false
                }
            }
        
        VStack {
            Spacer()
            
            HStack(spacing: 1) {
                Button(action: {
                    showOptions = false
                    showActionSheet = true
                }) {
                    Text("편지 불러오기")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                }
                Button(action: {
                    showOptions = false
                }) {
                    Text("편지 쓰기")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                }
            }
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom, getSafeAreaBottom() + 25)
        }
        .transition(.move(edge: .bottom))
    }
}

func getSafeAreaBottom() -> CGFloat {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    return windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
}

