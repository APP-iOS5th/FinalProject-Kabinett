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
    var letter: Letter
    
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
                
                TabView(selection: $selectedIndex) {
                    ForEach(Array(zip(letter.content.indices, letter.content)), id: \.0) { index, page in
                        VStack {
                            ContentRectangleView2(stationeryImageUrlString: letter.stationeryImageUrlString, fromUserName: letter.fromUserName, toUserName: letter.toUserName, letterContent: page, fontString: letter.fontString ?? "SFDisplay", date: letter.date)
                            
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
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
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .aspectRatio(9/13, contentMode: .fit)
                .frame(width: geometry.size.width * 0.88)
                .foregroundColor(.contentPrimary)
                .overlay(
                    Text(letterContent)
                        .foregroundColor(.white)
                        .padding()
                )
                .font(.custom(fontString, size: 13))
                .shadow(radius: 5, x: 5, y: 5)
                .padding(.horizontal, geometry.size.width * 0.06)
                .padding(.bottom, 30)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

struct ContentRectangleView2: View {
    var stationeryImageUrlString: String?
    var fromUserName: String
    var toUserName: String
    var letterContent: String
    var fontString: String
    var date: Date
    
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
                    // TODO: - 첫번째 페이지에서는 toUserName 만, 마지막 페이지에서는 date, fromUserName 만 보이도록 opacity 조절
                    Text("\(toUserName)에게")
                        .font(.custom(fontString, size: 14))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, geometry.size.height * 0.2)
                        .padding(.leading, 10)
                    
                    Text(letterContent)
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
                    
                    Text("\(fromUserName)가")
                        .font(.custom(fontString, size: 14))
                        .foregroundStyle(.contentPrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, geometry.size.height * 0.2)
                }
                .padding(.horizontal, geometry.size.width * 0.06)
                .frame(width: geometry.size.width * 0.88, height: geometry.size.height)
            }
            .padding(.bottom, 20)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
}


//// Array safe index extension
//extension Collection {
//    subscript(safe index: Index) -> Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}

#Preview {
    LetterCell(letter: LetterBoxUseCaseStub.sampleSearchOfDateLetters[0])
}
