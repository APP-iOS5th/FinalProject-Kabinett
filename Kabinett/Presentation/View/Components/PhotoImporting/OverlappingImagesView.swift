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
        ZStack {
            ForEach(Array(images.prefix(3).enumerated()), id: \.offset) { index, imageData in
                if let uiImage = UIImage(data: imageData) {
                    ImageView(uiImage: uiImage, index: index, totalImages: images.prefix(3).count)
                }
            }
        }
        .frame(width: 350, height: 210)
        .onTapGesture {
            showDetailView = true
        }
    }
}

struct ImageView: View {
    let uiImage: UIImage
    let index: Int
    let totalImages: Int
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: frameSize.width, height: frameSize.height)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .rotationEffect(.degrees(rotationAngle))
            .offset(offsetForImage)
            .shadow(radius: 5)
    }
    
    private var frameSize: CGSize {
        let aspectRatio = uiImage.size.width / uiImage.size.height
        if aspectRatio > 1.2 {
            return CGSize(width: 322, height: 201)
        } else if aspectRatio < 0.8 {
            return CGSize(width: 158, height: 210)
        } else {
            return CGSize(width: 210, height: 210)
        }
    }
    
    private var rotationAngle: Double {
        switch index {
        case 0: return 0
        case 1: return totalImages == 2 ? -5 : 5
        case 2: return -5
        default: return 0
        }
    }
    
    private var offsetForImage: CGSize {
        let aspectRatio = uiImage.size.width / uiImage.size.height
        switch (aspectRatio, index, totalImages) {
        case (1.2..., 0, _):
            return CGSize(width: 0, height: 0)
        case (1.2..., 1, 2):
            return CGSize(width: -20, height: 20)
        case (1.2..., 1, 3):
            return CGSize(width: -10, height: 10)
        case (1.2..., 2, _):
            return CGSize(width: -20, height: 20)
        case (...0.8, 0, _):
            return CGSize(width: -70, height: 0)
        case (...0.8, 1, _):
            return CGSize(width: 0, height: 0)
        case (...0.8, 2, _):
            return CGSize(width: 70, height: 0)
        case (_, 0, _):
            return CGSize(width: -35, height: -10)
        case (_, 1, _):
            return CGSize(width: 35, height: 0)
        case (_, 2, _):
            return CGSize(width: 0, height: 10)
        default:
            return CGSize.zero
        }
    }
}
