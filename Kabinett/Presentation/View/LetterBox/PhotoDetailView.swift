//
//  PhotoDetailView.swift
//  Kabinett
//
//  Created by uunwon on 11/11/24.
//

import SwiftUI
import Kingfisher

struct PhotoDetailView: View {
    let photoUrl: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            KFImage(URL(string: photoUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                Spacer()
                Button(action: {
                    // 사진 저장
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 30)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.trailing, 4)
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
}
