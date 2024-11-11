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
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            KFImage(URL(string: photoUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .offset(x: offset.width, y: offset.height)
                .onAppear {
                    self.scale = 1.0
                    self.lastScaleValue = 1.0
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            self.scale = max(1.0, lastScaleValue * value)
                        }
                        .onEnded { _ in
                            self.lastScaleValue = self.scale
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.offset = CGSize(
                                width: lastOffset.width + gesture.translation.width,
                                height: lastOffset.height + gesture.translation.height
                            )
                        }
                        .onEnded { _ in
                            self.lastOffset = offset
                        }
                )
            
            VStack {
                Spacer()
                
                Button(action: {
                    savePhotoToAlbum()
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.trailing, 4)
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
    
    private func savePhotoToAlbum() {
        guard let url = URL(string: photoUrl) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            } else {
                print("사진을 불러오지 못했습니다:", error?.localizedDescription ?? "알 수 없는 오류")
            }
        }.resume()
    }
}
