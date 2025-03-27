//
//  ContentWriteCell.swift
//  Kabinett
//
//  Created by Song Kim on 3/27/25.
//

import SwiftUI
import Kingfisher

struct TypingView: View {
    let index: Int
    @Binding var letter: WriteLetter
    @ObservedObject var viewModel: ContentWriteViewModel
    
    var body: some View {
        ZStack {
            KFImage(URL(string: letter.stationeryImageUrlString))
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
            
            VStack {
                Text(index == 0 ? letter.toUserName : "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, screenHeight * 0.05)
                    .padding(.bottom, screenHeight * 0.01)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                GeometryReader { geo in
                    if index < viewModel.texts.count {
                        CustomTextEditor(
                            maxWidth: geo.size.width,
                            maxHeight: geo.size.height,
                            font: FontUtility.selectedUIFont(font: letter.fontString ?? "", size: FontUtility.fontSize(font: letter.fontString ?? "")),
                            text: $viewModel.texts[index]
                        )
                    }
                }
                .onChange(of: viewModel.texts.count) {
                    letter.content = viewModel.texts
                }
                
                Text(index == (viewModel.texts.count-1) ? (letter.date).formattedString() : "")
                    .padding(.bottom, screenHeight * 0.00001)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text(index == (viewModel.texts.count-1) ? letter.fromUserName : "")
                    .padding(.bottom, screenHeight * 0.05)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, screenWidth * 0.08)
        }
    }
}

struct PolaroidView: View {
    let index: Int
    let uiImage: UIImage
    @Binding var letter: WriteLetter
    @ObservedObject var viewModel: ContentWriteViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: uiImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .aspectRatio(contentMode: .fit)
                .padding([.horizontal, .top], 10)
                .padding(.bottom, screenWidth * 0.12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: .primary300, radius: 5, x: 3, y: 3)
                .padding([.top, .bottom], 10)
            
            Button(action: {
                viewModel.selectedItems.remove(at: viewModel.currentIndex - viewModel.texts.count)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.trailing, -10)
                    .foregroundColor(Color(.primary900))
            }
        }
        .frame(width: screenWidth * 0.88)
    }
}
