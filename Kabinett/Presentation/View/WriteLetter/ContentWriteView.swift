//
//  WirteLetter.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct ContentWriteView: View {
    @Binding var letterContent: LetterWriteModel
    @EnvironmentObject var viewModel: ContentWriteViewModel
    @EnvironmentObject var customViewModel: CustomTabViewModel
    @EnvironmentObject var fontViewModel: FontSelectionViewModel
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                NavigationBarView(titleName: "", isColor: true) {
                    NavigationLink(destination: EnvelopeStampSelectionView(letterContent: $letterContent)) {
                        Text("다음")
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundStyle(.contentPrimary)
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                
                HStack {
                    ScrollViewReader { scrollViewProxy in
                        ZStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: UIScreen.main.bounds.width * 0.04) {
                                    ForEach(0..<viewModel.pageCnt, id: \.self) { i in
                                        VStack {
                                            ZStack {
                                                KFImage(URL(string: letterContent.stationeryImageUrlString ?? ""))
                                                    .placeholder {
                                                        ProgressView()
                                                    }
                                                    .resizable()
                                                    .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
                                                    .padding(.top, 10)
                                                
                                                VStack {
                                                    HStack {
                                                        Text(i == 0 ? letterContent.toUserName : "")
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .onTapGesture {
                                                                UIApplication.shared.endEditing()
                                                            }
                                                        Spacer()
                                                        
                                                        Button {
                                                            customViewModel.showPhotoLibrary = true
                                                            customViewModel.isLetterWrite = true
                                                        } label: {
                                                            Image(systemName: "photo.on.rectangle.angled")
                                                                .font(.system(size: 15))
                                                                .padding(.horizontal, 13)
                                                                .padding(.vertical, 8)
                                                                .foregroundStyle(letterContent.photoContents.isEmpty ? Color(.primary900) : Color.white)
                                                                .background(letterContent.photoContents.isEmpty ? Color(.primary300) : Color(.primary900))
                                                                .clipShape(Capsule())
                                                        }
                                                    }
                                                    .padding(.top, 45)
                                                    .padding(.leading, 2)
                                                    .padding(.bottom, 3)
                                                    
                                                    let pageText = Binding(
                                                        get: { viewModel.getPageText(for: i) },
                                                        set: { newValue in
                                                            viewModel.updateText(for: i, with: newValue)
                                                        }
                                                    )
                                                    
                                                    TextEditor(text: pageText)
                                                        .kerning(22)
                                                        .lineSpacing(5)
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                        .scrollContentBackground(.hidden)
                                                        .background(Color.clear)
                                                    
                                                    Text(i == (viewModel.pageCnt-1) ? (letterContent.date).formattedString() : "")
                                                        .padding(.trailing, 2)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                    
                                                    Text(i == (viewModel.pageCnt-1) ? letterContent.fromUserName : "")
                                                        .padding(.bottom, 30)
                                                        .padding(.trailing, 2)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                }
                                                .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
                                            }
                                            .aspectRatio(9/13, contentMode: .fit)
                                            .frame(width: UIScreen.main.bounds.width * 0.88)
                                            Spacer()
                                        }
                                    }
                                }
                                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .font(fontViewModel.selectedFont(font: letterContent.fontString ?? "", size: 15))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
        .onChange(of: viewModel.text) {
            viewModel.adjustPageCount()
        }
    }
}
