//
//  WirteLetter.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import SwiftUI
import UIKit
import Kingfisher
import PhotosUI
import FirebaseAnalytics

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct ContentWriteView: View {
    @Binding var letter: WriteLetter
    @StateObject var viewModel = ContentWriteViewModel()
    @ObservedObject var customTabViewModel: CustomTabViewModel
    @StateObject var fontViewModel = FontSelectionViewModel()
    
    init(
        letter: Binding<WriteLetter>,
        customTabViewModel: CustomTabViewModel
    ) {
        self.customTabViewModel = customTabViewModel
        self._letter = letter
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.background).ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            ZStack(alignment: .top) {
                VStack {
                    ScrollableLetterView(letter: $letter, viewModel: viewModel)
                        .font(FontUtility.selectedFont(font: letter.fontString ?? "", size: 13))
                    
                    Text("\(viewModel.currentIndex+1) / \(viewModel.texts.count+viewModel.photoContents.count)")
                        .padding(5)
                        .padding(.horizontal, 8)
                        .background(Color(.primary900).opacity(0.3))
                        .clipShape(Capsule())
                }
                .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.03, forOthers: 0.0))
                MiniTabBarView(viewModel: viewModel, customTabViewModel: customTabViewModel)
                
                if viewModel.isKeyboard {
                    Button(action:{
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
                        )
                    }){
                        Image(systemName: "keyboard.chevron.compact.down")
                            .padding(12)
                            .foregroundStyle(Color.white)
                            .background(Color.primary900)
                            .clipShape(Circle())
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.488)
                    .padding(.leading, UIScreen.main.bounds.width * 0.85)
                }
            }
        }
        .overlay { // 폰트 선택뷰
            if viewModel.showFontMenu {
                FontMenuView(letter: $letter, showFontMenu: $viewModel.showFontMenu, fontViewModel: fontViewModel)
            }
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: viewModel.selectedItems) { // 이미지가 변경될 때
            Task { @MainActor in
                await viewModel.loadImages()
                letter.photoContents = viewModel.photoContents
            }
        }
        .onAppear{ // 키보드 감지
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                    viewModel.isKeyboard = true
                }
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    viewModel.isKeyboard = false
                }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: EnvelopeStampSelectionView(
                    letter: $letter,
                    customTabViewModel: customTabViewModel
                )) {
                    Text("다음")
                        .fontWeight(.medium)
                        .font(.system(size: 19))
                        .foregroundStyle(.contentPrimary)
                }
            }
        }
        .analyticsScreen( // 화면 추적
            name: "\(type(of:self))",
            extraParameters: [
                AnalyticsParameterScreenName: "\(type(of:self))",
                AnalyticsParameterScreenClass: "\(type(of:self))",
            ]
        )
    }
}

// MARK: ScrollableLetterView
struct ScrollableLetterView: View {
    @Binding var letter: WriteLetter
    @ObservedObject var viewModel: ContentWriteViewModel
    @State private var scrollWorkItem: DispatchWorkItem?
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollViewProxy in
                ZStack(alignment: .top) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        GeometryReader { proxy in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetKey.self,
                                    value: proxy.frame(in: .global).origin.x
                                )
                        }
                        .frame(height: 0)
                        LazyHStack(alignment: .top, spacing: geometry.size.width * 0.04) {
                            ForEach(viewModel.texts.indices, id: \.self) { i in
                                TypingView(index: i, letter: $letter, viewModel: viewModel)
                                    .onChange(of: viewModel.texts[i]) {
                                        letter.content = viewModel.texts
                                    }
                                    .padding(.top, 10)
                                    .aspectRatio(9/13, contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.88)
                                    .id(i)
                            }
                            
                            ForEach(viewModel.photoContents.indices, id: \.self) { index in
                                let imageIndex = index + viewModel.texts.count
                                if let uiImage = UIImage(data: viewModel.photoContents[index]) {
                                    PolaroidView(index: imageIndex, uiImage: uiImage, letter: $letter, viewModel: viewModel)
                                        .frame(width: geometry.size.width * 0.88)
                                        .id(imageIndex)
                                }
                            }
                        }
                        .padding(.horizontal, geometry.size.width * 0.06)
                    }
                    .scrollTargetLayout()
                    .scrollTargetBehavior(.viewAligned)
                    .onPreferenceChange(ScrollOffsetKey.self) { newOffset in
                        viewModel.offset = newOffset
                        
                        let pageWidth = screenWidth * 0.9204
                        let rawIndex = -viewModel.offset / pageWidth
                        let nearestIndex = Int(round(rawIndex))
                        
                        if viewModel.currentIndex != nearestIndex {
                            viewModel.currentIndex = nearestIndex
                        }
                    }
                }
                .onChange(of: viewModel.texts.count) {
                    withAnimation(.spring()) {
                        scrollViewProxy.scrollTo(viewModel.currentIndex+1, anchor: .center)
                    }
                }
                .onAppear {
                    DispatchQueue.main.async {
                        scrollViewProxy.scrollTo(viewModel.currentIndex, anchor: .center)
                    }
                }
            }
        }
    }
}


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
                            text: $viewModel.texts[index],
                            maxWidth: geo.size.width,
                            maxHeight: geo.size.height,
                            font: FontUtility.selectedUIFont(font: letter.fontString ?? "", size: FontUtility.fontSize(font: letter.fontString ?? ""))
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
            .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
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
                .padding(.bottom, UIScreen.main.bounds.width * 0.12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: .primary300, radius: 5, x: 3, y: 3)
                .padding([.top, .bottom], 10)
            
            Button(action: {
                viewModel.selectedItems.remove(at: index)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.trailing, -10)
                    .foregroundColor(Color(.primary900))
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.88)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
