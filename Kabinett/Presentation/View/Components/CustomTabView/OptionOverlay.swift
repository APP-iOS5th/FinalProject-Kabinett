//
//  OptionOverlay.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI

struct OptionOverlay: View {
    @ObservedObject var viewModel: CustomTabViewModel
    
    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    viewModel.hideOptions()
                }
            }
        
        VStack {
            Spacer()
            
            HStack(spacing: 1) {
                Button(action: {
                    viewModel.showImportDialogAndHideOptions()
                }) {
                    Text("편지 불러오기")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                }
                Button(action: {
                    viewModel.showWriteLetterViewAndHideOptions()
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
            .padding(.bottom, viewModel.getSafeAreaBottom() + 25)
        }
        .transition(.move(edge: .bottom))
    }
}


