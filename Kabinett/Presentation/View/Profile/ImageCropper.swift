//
//  ImageCropper.swift
//  Kabinett
//
//  Created by Yule on 8/27/24.
//

import SwiftUI

struct ImageCropper: View {
    @ObservedObject var viewModel: ProfileSettingsViewModel
    @Binding var isShowingCropper: Bool
    let image: UIImage?
    @State var cropArea: CGRect = .init(x: 0, y: 0, width: 110, height: 110)
    @State var imageViewSize: CGSize = .zero
    @State var croppedImage: UIImage? = nil

    var body: some View {
        if let image = image {
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
                        .onChange(of: geometry.size) {
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