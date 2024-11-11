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
            
            ZoomableScrollView {
                KFImage(URL(string: photoUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            VStack {
                Spacer()
                Button(action: {
                    savePhotoToAlbum()
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
    
    func savePhotoToAlbum() {
        guard let url = URL(string: photoUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            } else {
                print("사진을 불러오지 못했습니다.", error?.localizedDescription ?? "알 수 없는 오류")
            }
        }.resume()
    }
}
