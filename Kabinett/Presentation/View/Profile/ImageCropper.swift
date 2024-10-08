//
//  ImageCropper.swift
//  Kabinett
//
//  Created by Yule on 8/27/24.
//

import SwiftUI

struct ImageCropper: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var isShowingCropper: Bool
    let imageToCrop: UIImage?
    @State var cropArea: CGRect = .init(x: 0, y: 0, width: 110, height: 110)
    @State var imageViewSize: CGSize = .zero
    @State var croppedImage: UIImage? = nil
    
    var body: some View {
        if let image = imageToCrop?.normalized() {
            VStack {
                Spacer()
                imageView(image: image)
                Spacer()
                actionButtons(image: image)
                if let croppedImage = croppedImage {
                    croppedImageView(croppedImage: croppedImage)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
        } else {
            Text("No image available for cropping.")
        }
    }
    
    @ViewBuilder
    private func imageView(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .overlay(alignment: .topLeading) {
                GeometryReader { geometry in
                    CropBox(rect: $cropArea)
                        .onAppear {
                            self.imageViewSize = geometry.size
                        }
                        .onChange(of: geometry.size) { _, _ in
                            self.imageViewSize = geometry.size
                        }
                }
            }
    }
    
    @ViewBuilder
    private func actionButtons(image: UIImage) -> some View {
        HStack {
            Button(action: {
                isShowingCropper = false
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("이미지 자르기")
                .fontWeight(.medium)
                .font(.system(size: 18))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                viewModel.crop(image: image, cropArea: cropArea, imageViewSize: imageViewSize)
                croppedImage = viewModel.croppedImage
            }) {
                Image(systemName: "checkmark")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 350)
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    private func croppedImageView(croppedImage: UIImage) -> some View {
        Image(uiImage: croppedImage)
            .resizable()
            .scaledToFit()
            .frame(width: 110)
    }
}

extension UIImage {
    func normalized() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale) // 새로운 캔버스 만들기
        self.draw(in: CGRect(origin: .zero, size: self.size)) // heic의 이미지 회전 정보를 무시하고 새로 그림
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? self
    }
}
