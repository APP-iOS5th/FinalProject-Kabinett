//
//  OverlappingImagesView.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import SwiftUI

struct OverlappingImagesView: View {
    let images: [Data]
    @Binding var showDetailView: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(images.prefix(3).enumerated().reversed()), id: \.offset) { index, imageData in
                    if let uiImage = UIImage(data: imageData) {
                        ImageView(uiImage: uiImage, index: index, totalImages: images.prefix(3).count, parentSize: geometry.size)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onTapGesture {
                showDetailView = true
            }
        }
    }
}

struct ImageView: View {
    let uiImage: UIImage
    let index: Int
    let totalImages: Int
    let parentSize: CGSize
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: frameSize.width, height: frameSize.height)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .rotationEffect(.degrees(rotationAngle), anchor: .center)
            .position(x: parentSize.width / 2, y: parentSize.height / 2)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    private var frameSize: CGSize {
        let aspectRatio = uiImage.size.width / uiImage.size.height
        let maxWidth = parentSize.width * 0.6
        let maxHeight = parentSize.height * 0.5
        
        if aspectRatio > 1 {
            let height = min(maxHeight, maxWidth / aspectRatio)
            return CGSize(width: height * aspectRatio, height: height)
        } else {
            let width = min(maxWidth, maxHeight * aspectRatio)
            return CGSize(width: width, height: width / aspectRatio)
        }
    }
    
    private var rotationAngle: Double {
        Double(index) * -15
    }
}
