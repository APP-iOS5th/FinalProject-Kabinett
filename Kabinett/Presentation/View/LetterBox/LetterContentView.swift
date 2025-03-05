//
//  LetterContentView.swift
//  Kabinett
//
//  Created by uunwon on 8/29/24.
//

import SwiftUI
import Kingfisher
import FirebaseAnalytics

struct LetterContentView: View {
    @State private var selectedIndex: Int = 0
    @State private var isPhotoDetailPresented: Bool = false
    @State private var selectedPhotoUrl: String?

    var letter: Letter
    
    private var totalPageCount: Int {
        return LetterHelper.calculateTotalPageCount(for: letter)
    }
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
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
                                if index == selectedIndex || index == selectedIndex + 1 || index == selectedIndex - 1 {
                                    createPageView(index: index, geometry: geometry)
                                        .offset(x: calculateOffset(for: index, geometry: geometry))
                                        .offset(y: calculateStackOffset(for: index))
                                        .zIndex(Double(totalPageCount - abs(selectedIndex - index)))
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
            .navigationDestination(isPresented: $isPhotoDetailPresented) {
                if let selectedPhotoUrl = selectedPhotoUrl {
                    PhotoDetailView(photoUrl: selectedPhotoUrl)
                }
            }
        }
        .analyticsScreen(
            name: "\(type(of:self))",
            extraParameters: [
                AnalyticsParameterScreenName: "\(type(of:self))",
                AnalyticsParameterScreenClass: "\(type(of:self))",
            ]
        )
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
                .offset(x: index < selectedIndex ? -geometry.size.width * 0.02 : 0)
            } else if !letter.photoContents.isEmpty && index >= letter.content.count {
                displayPhoto(index: index - letter.content.count, geometry: geometry)
                    .offset(x: index < selectedIndex ? -geometry.size.width * 0.02 : 0)
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
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .padding(.bottom, UIScreen.main.bounds.width * 0.12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(width: geometry.size.width * 0.84)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .shadow(color: .primary300, radius: 5, x: 3, y: 3)
            .onTapGesture {
                selectedPhotoUrl = letter.photoContents[index]
                isPhotoDetailPresented = true
            }
    }
    
    private func calculateOffset(for index: Int, geometry: GeometryProxy) -> CGFloat {
        let pageWidth = geometry.size.width * 0.88
        if index < selectedIndex {
            return -pageWidth * 0.999
        } else if index > selectedIndex {
            return pageWidth * 0.03
        } else {
            return 0
        }
    }
    
    private func calculateStackOffset(for index: Int) -> CGFloat {
        if index > selectedIndex {
            return CGFloat(index - selectedIndex) * 15
        } else {
            return 0
        }
    }
}
