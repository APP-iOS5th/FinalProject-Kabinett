//
//  OverlappingImagesView.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import SwiftUI

struct OverlappingImagesView: View {
    let images: [IdentifiableImage]
    
    var body: some View {
        ZStack {
            ZStack {
                ForEach(Array(images.enumerated()), id: \.element.id) { index, imageItem in
                    Image(uiImage: imageItem.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 322, height: 201)
                        .rotationEffect(
                            index == 0 ? .degrees(0) : .degrees(Double(index % 2 == 0 ? index * 5 : index * -5))
                        )
                        .offset(x: CGFloat(index), y: CGFloat(index) * (40 + CGFloat(index) * 5))
                        .shadow(radius: 8)
                }
            }
            .frame(width: 350, height: 210)
            .onTapGesture {
            }
        }
    }
}
