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
    let savedColor = Color(UIColor(red: 95/255, green: 239/255, blue: 155/255, alpha: 1))
    
    @State private var isPhotoSaved: Bool = false
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
                    if !isPhotoSaved {
                        Task {
                            await savePhotoToAlbum()
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(isPhotoSaved ? savedColor : .contentPrimary)
                            .frame(width: isPhotoSaved ? 35 : 37)
                        
                        Image(systemName: isPhotoSaved ? "checkmark" : "square.and.arrow.down")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(isPhotoSaved ? .black : .white)
                            .padding(.bottom, isPhotoSaved ? 0 : 5)
                    }
                }
                .padding(.bottom, 10)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.contentPrimary)
                                .frame(width: 31, height: 31)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white)
                        }
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
                isPhotoSaved = true
            } else {
                print("이미지 변환에 실패했습니다.")
            }
        } catch {
            print("사진을 불러오지 못했습니다.", error.localizedDescription)
        }
    }
}
