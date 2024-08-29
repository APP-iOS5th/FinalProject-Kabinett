//
//  LetterWritePreviewView.swift
//  Kabinett
//
//  Created by Song Kim on 8/29/24.
//

import SwiftUI
import Kingfisher

struct LetterWritePreviewView: View {
    @Binding var letterContent: LetterWriteViewModel
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            GeometryReader { geo in
                VStack {
                    NavigationBarView(destination: LetterWritePreviewView(letterContent: $letterContent), titleName: "", isNavigation: false)
                        .padding(.bottom, geo.size.height * 0.3)
                    
                    ZStack(alignment: .topLeading) {
                        KFImage(URL(string: letterContent.envelopeImageUrlString))
                            .resizable()
                            .shadow(radius: 5, x: 5, y: 5)
                        
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
                                
                                KFImage(URL(string: letterContent.stampImageUrlString))
                                    .resizable()
                                    .aspectRatio(9/9.7, contentMode: .fit)
                                    .frame(width: geo.size.width * 0.1)
                                    .padding(.trailing, 25)
                            }
                            .padding(.top, 25)
                            
                            Spacer()
                            
                            HStack(alignment: .top) {
                                VStack {
                                    Text(letterContent.postScript ?? "")
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
                            .padding(.bottom, 25)
                        }
                        
                    }
                    .aspectRatio(9/4, contentMode: .fit)
                    .padding(.bottom, 30)
                    
                    VStack {
                        Text("편지가 완성되었어요.")
                            .font(.system(size: 18, weight: .semibold))
                        HStack {
                            Text("\(letterContent.toUserName == letterContent.fromUserName ? "나" : letterContent.toUserName)")
                                .font(.system(size: 22, weight: .bold))
                                .padding(.trailing, -3)
                            Text("에게 편지를 보낼까요?")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .padding(.top, -5)
                    }
                    
                    Spacer()

                    Button {
                        
                    } label : {
                        Text("편지 보내기")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.white)
                    }
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color("Primary900"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
    }
}
