//
//  WirteLetter.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import SwiftUI

struct WriteLetterView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = WriteLetterViewModel()
    @ObservedObject private var fontViewModel = FontSelectionViewModel()
    
    @State var text: String = ""
    @State var pageCnt: Int = 1
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    NavigationBarView(destination: WriteLetterView(letterContent: $letterContent), titleName: "")
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                    HStack {
                        ZStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: geometry.size.width * 0.04) {
                                    ForEach(0..<10) { i in
                                        ZStack {
                                            // 편지지 이미지 뷰
                                            AsyncImage(url: URL(string: letterContent.stationeryImageUrlString ?? "")) { image in
                                                image
                                                    .resizable()
                                                    .shadow(radius: 5, x: 5, y: 5)
                                                    .padding(.top, 10)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            
                                            ZStack {
                                                // 편지 쓰는 뷰
                                                TextEditor(text: $text)
                                                    .lineLimit(16)
                                                    .background(Color.white)
                                                    .kerning(22)
                                                    .lineSpacing(5)
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .aspectRatio(8/9, contentMode: .fit)
                                                    .onChange(of: text) {
                                                        if text.filter({ $0 == "\n" }).count >= 16 * pageCnt {
                                                            pageCnt += 1
                                                        } else if text.filter({ $0 == "\n" }).count <= 16 * pageCnt && pageCnt > 1 {
                                                            pageCnt -= 1
                                                        }
                                                    }
                                                
                                                // ~에게 ~가 뷰
                                                VStack {
                                                    Text(letterContent.fromUserName)
                                                        .padding(.top, 45)
                                                        .padding(.leading, 2)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    Spacer()
                                                    
                                                    Text(letterContent.toUserName)
                                                        .padding(.trailing, 2)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                    
                                                    Text(viewModel.formatDate(letterContent.date))
                                                        .padding(.bottom, 27)//
                                                        .padding(.trailing, 2)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                }
                                            }
                                            .padding(.horizontal, 24)
                                        }
                                        .aspectRatio(9/13, contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.88)
                                    }
                                }
                                .padding(.horizontal, geometry.size.width * 0.06)
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .frame(height: geometry.size.height * 0.7)
                        .font(fontViewModel.font(file: letterContent.fontString ?? "SFDisplay"))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ModalTestView()
}
