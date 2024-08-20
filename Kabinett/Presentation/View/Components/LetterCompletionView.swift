//
//  LetterCompletionView.swift
//  Kabinett
//
//  Created by 김정우 on 8/20/24.
//

import SwiftUI

struct LetterCompletionView: View {
    let fromUser: String
    let toUser: String
    let date: Date
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        // 이전 페이지 (다른분 작업뷰와 연결)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.white)
                        .frame(width: 315, height: 145)
                        .shadow(radius: 5)
                    
                    GeometryReader { geometry in
                        ZStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("보내는 사람")
                                    .font(.system(size: 7))
                                
                                Text(fromUser)
                                    .font(.system(size: 14))
                            }
                            .position(x: 60, y: 35)
                            
                            Text(dateFormatter.string(from: date))
                                .font(.system(size: 12))
                                .position(x: geometry.size.width - 80, y: 25)
                            
                            Text("사진 몇 장 같이 넣어뒀어!")
                                .font(.system(size: 10))
                                .position(x: 85, y: geometry.size.height - 35)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("받는 사람")
                                    .font(.system(size: 7))
                                Text(toUser)
                                    .font(.system(size: 14))
                            }
                            .position(x: geometry.size.width - 90, y: geometry.size.height - 30)
                            
                            // 임시 우표
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 34, height: 38)
                                .foregroundColor(.green)
                                .position(x: geometry.size.width - 40, y: 35)
                        }
                    }
                }
                .frame(width: 315, height: 145)
                
                VStack(spacing: 10) {
                    Text("편지가 완성되었어요.")
                    Text("소중한 편지를 보관할게요.")
                }
                .font(.system(size: 18, weight: .medium))
                
                Spacer()
                
                Button(action: {
                    // 편지 저장
                }) {
                    Text("편지 보관하기")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Primary900"))
                        .cornerRadius(14)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    LetterCompletionView(fromUser: "Dotorie", toUser: "YULE", date: Date())
}
