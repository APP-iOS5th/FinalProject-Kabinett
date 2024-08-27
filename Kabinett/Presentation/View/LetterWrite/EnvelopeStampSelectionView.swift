//
//  EnvelopeSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/27/24.
//

import SwiftUI
import Kingfisher

struct EnvelopeStampSelectionView: View {
    @Binding var letterContent: LetterWriteViewModel
    @StateObject private var viewModel = EnvelopeStampSelectionViewModal()
    
    @State var text: String = ""
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    NavigationBarView(destination: WriteLetterView(letterContent: $letterContent), titleName: "봉투와 우표 고르기")
                        .padding(.bottom, 25)
                    
                    VStack {
                        ZStack(alignment: .topLeading) {
                            Rectangle() // 편지지 이미지로 변경 할 예정
                                .fill(Color.white)
                                .shadow(radius: 5, x: 5, y: 5)
                                .frame(width: .infinity, height: .infinity)
                            
                            VStack {
                                HStack(alignment: .top) {
                                    VStack {
                                        Text("보내는 사람")
                                            .font(.system(size: 7))
                                            .padding(.bottom, 1)
                                        Text(letterContent.fromUserName)
                                            .font(.custom(letterContent.fontString ?? "SFDisplay", size: 14))
                                    }
                                    .padding(.leading, 25)
                                    
                                    Spacer()
                                    
                                    Rectangle() // 우표 이미지로 변경 할 예정
                                        .fill(Color.red)
                                        .aspectRatio(9/9.7, contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.1, height: .infinity)
                                        .padding(.trailing, 25)
                                }
                                .padding(.top, 25)
                                
                                Spacer()
                                
                                HStack(alignment: .top) {
                                    VStack {
                                        Text(text)
                                            .font(.custom(letterContent.fontString ?? "SFDisplay", size: 10))
                                    }
                                    .padding(.leading, 25)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("받는 사람")
                                            .font(.system(size: 7))
                                            .padding(.bottom, 1)
                                        Text(letterContent.toUserName)
                                            .font(.custom(letterContent.fontString ?? "SFDisplay", size: 14))
                                    }
                                    .padding(.trailing, 100)
                                }
                                .padding(.bottom, 30)
                            }

                        }
                        .aspectRatio(9/4, contentMode: .fit)
                        .padding(.bottom, 50)
                        
                        VStack(alignment: .leading) {
                            Text("봉투에 적을 내용")
                                .font(.system(size: 13))
                                .padding(.bottom, 1)
                            TextField("최대 15자까지 적을 수 있습니다 ~", text: $text)
                                .maxLength(text: $text, 15)
                                .padding(.leading, 6)
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, minHeight: 35, alignment: .leading)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .padding(.bottom, 30)
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ModalTestView()
}
