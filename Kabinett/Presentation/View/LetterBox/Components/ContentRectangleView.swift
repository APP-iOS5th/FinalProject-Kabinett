//
//  ContentRectangleView.swift
//  Kabinett
//
//  Created by uunwon on 9/10/24.
//

import SwiftUI
import Kingfisher

struct ContentRectangleView: View {
    var stationeryImageUrlString: String?
    var fromUserName: String
    var toUserName: String
    var letterContent: String
    var fontString: String
    var date: Date
    
    var currentPageIndex: Int
    var totalPages: Int
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .background(
                        (stationeryImageUrlString != nil) ?
                        AnyView(KFImage(URL(string: stationeryImageUrlString!))
                            .resizable()) :
                            AnyView(Color.white)
                    )
                    .shadow(color: .primary300, radius: 5, x: 3, y: 3)
                
                VStack {
                    Text(toUserName)
                        .font(FontUtility.selectedFont(font: fontString, size: 14))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, screenHeight * 0.05)
                        .opacity(currentPageIndex == 0 ? 1 : 0)
                    
                    Text(letterContent.forceCharWrapping)
//                        .lineSpacing(FontUtility.lineSpacing(font: fontString))
//                        .kerning(FontUtility.kerning(font: fontString))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, screenHeight * 0.01)
                        .font(Font(FontUtility.selectedUIFont(font: fontString, size: FontUtility.fontSize(font: fontString))))
                    
                    Spacer()
                    
                    Text(formattedDate(date: date))
                        .font(FontUtility.selectedFont(font: fontString, size: 14))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, screenHeight * 0.00001)
                        .opacity(currentPageIndex == max(totalPages - 1, 0) ? 1 : 0)
                    
                    Text(fromUserName)
                        .font(FontUtility.selectedFont(font: fontString, size: 14))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, screenHeight * 0.05)
                        .opacity(currentPageIndex == max(totalPages - 1, 0) ? 1 : 0)
                }
                
                .padding(.horizontal, screenWidth * 0.08)
            }
            .aspectRatio(9/13, contentMode: .fit)
            .frame(width: screenWidth * 0.88)
            .padding(.bottom, 30)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
}
