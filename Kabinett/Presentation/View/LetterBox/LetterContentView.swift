//
//  LetterContentView.swift
//  Kabinett
//
//  Created by uunwon on 8/29/24.
//

import SwiftUI
import Kingfisher

struct LetterContentView: View {
    @State private var selectedIndex: Int = 0
    var letter: Letter
    
    private var totalPageCount: Int {
        return LetterHelper.calculateTotalPageCount(for: letter)
    }
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    
                    CloseButtonView { dismiss() }
                }
                
                GeometryReader { geometry in
                    ZStack {
                        ForEach(0..<max(totalPageCount, 1), id: \.self) { index in
                            if index == selectedIndex || index == selectedIndex + 1 {
                                createPageView(index: index, geometry: geometry)
                                    .offset(x: CGFloat(index - selectedIndex) * 10, y: CGFloat(index - selectedIndex) * 10)
                                    .zIndex(index == selectedIndex ? 1 : 0)
                                    .animation(.spring(), value: selectedIndex)
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                DragHelper.handlePageChangeGesture(value: value, selectedIndex: &selectedIndex, totalPageCount: totalPageCount)
                            }
                    )
                }
            }
        }
    }
   
    @ViewBuilder
    private func createPageView(index: Int, geometry: GeometryProxy) -> some View {
        if letter.content.isEmpty == false || (letter.content.isEmpty && letter.photoContents.isEmpty) {
            if index < letter.content.count {
                ContentRectangleView(
                    stationeryImageUrlString: letter.stationeryImageUrlString,
                    fromUserName: letter.fromUserName,
                    toUserName: letter.toUserName,
                    letterContent: letter.content[safe: index] ?? " ",
                    fontString: letter.fontString ?? "SFDisplay",
                    date: letter.date,
                    currentPageIndex: index,
                    totalPages: max(letter.content.count, 1)
                )
            } else if !letter.photoContents.isEmpty && index >= letter.content.count {
                displayPhoto(index: index - letter.content.count, geometry: geometry)
            } else {
                ContentRectangleView(
                    stationeryImageUrlString: letter.stationeryImageUrlString,
                    fromUserName: letter.fromUserName,
                    toUserName: letter.toUserName,
                    letterContent: " ",
                    fontString: letter.fontString ?? "SFDisplay",
                    date: letter.date,
                    currentPageIndex: 0,
                    totalPages: 1
                )
            }
        } else if letter.content.isEmpty && !letter.photoContents.isEmpty {
            displayPhoto(index: index, geometry: geometry)
        }
    }
    
    private func displayPhoto(index: Int, geometry: GeometryProxy) -> some View {
        KFImage(URL(string: letter.photoContents[index]))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width * 0.88)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .shadow(color: .primary300, radius: 5, x: 3, y: 3)
            .padding(.bottom, 30)
    }
}