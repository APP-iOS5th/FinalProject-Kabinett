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
                    Task {
                        await savePhotoToAlbum()
                    }
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
    
    func savePhotoToAlbum() async {
        guard let url = URL(string: photoUrl) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            } else {
                print("이미지 변환에 실패했습니다.")
            }
        } catch {
            print("사진을 불러오지 못했습니다.", error.localizedDescription)
        }
    }
}
