//
//  ContentRectangleView.swift
//  Kabinett
//
//  Created by uunwon on 9/10/24.
//

import SwiftUI
import Kingfisher

struct ContentRectangleView: View {
    @EnvironmentObject var fontViewModel: FontSelectionViewModel
    
    var stationeryImageUrlString: String?
    var fromUserName: String
    var toUserName: String
    var letterContent: String
    var fontString: String
    var date: Date
    
    var currentPageIndex: Int
    var totalPages: Int
    
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
                    .aspectRatio(9/13, contentMode: .fit)
                    .frame(width: geometry.size.width * 0.88)
                    .shadow(color: .primary300, radius: 5, x: 3, y: 3)
                
                VStack {
                    Text(toUserName)
                        .font(fontViewModel.selectedFont(font: fontString, size: 15))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, geometry.size.height * 0.2)
                        .padding(.leading, 10)
                        .opacity(currentPageIndex == 0 ? 1 : 0)
                    
                    Text(letterContent.forceCharWrapping)
                        .font(fontViewModel.selectedFont(font: fontString, size: fontViewModel.fontSize(font: fontString)))
                        .lineSpacing(fontViewModel.lineSpacing(font: fontString))
                        .kerning(fontViewModel.kerning(font: fontString))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 3)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Text(formattedDate(date: date))
                        .font(fontViewModel.selectedFont(font: fontString, size: 15))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 0.1)
                        .opacity(currentPageIndex == max(totalPages - 1, 0) ? 1 : 0)
                    
                    Text(fromUserName)
                        .font(fontViewModel.selectedFont(font: fontString, size: 15))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, geometry.size.height * 0.2)
                        .opacity(currentPageIndex == max(totalPages - 1, 0) ? 1 : 0)
                }
                .padding(.horizontal, geometry.size.width * 0.06)
                .frame(width: geometry.size.width * 0.88, height: geometry.size.height)
            }
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
