//
//  LetterView.swift
//  Kabinett
//
//  Created by uunwon on 8/29/24.
//

import SwiftUI
import Kingfisher

struct LetterCell: View {
    @State private var selectedIndex: Int = 0
    @Binding var letter: Letter
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    BeforeButtonView(selectedIndex: $selectedIndex)
                    
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
                                if value.translation.width < -50 && selectedIndex < totalPageCount - 1 {
                                    selectedIndex += 1
                                } else if value.translation.width > 50 && selectedIndex > 0 {
                                    selectedIndex -= 1
                                }
                            }
                    )
                }
            }
        }
    }
    
    private var totalPageCount: Int {
        return letter.content.count + letter.photoContents.count
    }
    
    @ViewBuilder
    private func createPageView(index: Int, geometry: GeometryProxy) -> some View {
        
        if letter.content.isEmpty || index < letter.content.count {
            ContentRectangleView(
                stationeryImageUrlString: letter.stationeryImageUrlString,
                fromUserName: letter.fromUserName,
                toUserName: letter.toUserName,
                letterContent: letter.content.isEmpty ? " " : letter.content[index].isEmpty ? " " : letter.content[index],
                fontString: letter.fontString ?? "SFDisplay",
                date: letter.date,
                currentPageIndex: index,
                totalPages: max(letter.content.count, 1)
            )
        } else {
            KFImage(URL(string: letter.photoContents[index - letter.content.count]))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width * 0.88)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .shadow(radius: 5, x: 5, y: 5)
                .padding(.bottom, 30)
        }
    }
}

struct BeforeButtonView: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
        Button(action: {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(.contentPrimary)
                .padding(.leading, 4)
        }
        .padding()
        .opacity(selectedIndex > 0 ? 1 : 0)
    }
}

struct CloseButtonView: View {
    var dismiss: () -> Void
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(.contentPrimary)
                .padding(.trailing, 4)
        }
        .padding()
    }
}

struct ContentRectangleView: View {
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
                    .shadow(radius: 5, x: 5, y: 5)
                
                VStack {
                    Text("\(toUserName)에게")
                        .font(.custom(fontString, size: 14))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, geometry.size.height * 0.2)
                        .padding(.leading, 10)
                        .opacity(currentPageIndex == 0 ? 1 : 0)
                    
                    Text(letterContent.forceCharWrapping)
                        .font(.custom(fontString, size: 14))
                        .foregroundStyle(.contentPrimary)
                        .lineSpacing(11)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 15)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Text(formattedDate(date: date))
                        .font(.custom(fontString, size: 14))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 0.1)
                        .opacity(currentPageIndex == max(totalPages - 1, 0) ? 1 : 0)
                    
                    Text("\(fromUserName)가")
                        .font(.custom(fontString, size: 14))
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

extension String {
    var forceCharWrapping: Self {
        self.map({ String($0) }).joined(separator: "\u{200B}")
    }
}

//#Preview {
//    LetterCell(letter: LetterBoxUseCaseStub.sampleSearchOfDateLetters[0])
//}
