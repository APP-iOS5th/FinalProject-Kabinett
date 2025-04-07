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
    @StateObject var fontViewModel = FontSelectionViewModel()
    @ObservedObject var customTabViewModel: CustomTabViewModel
    
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
                    .padding(.top, screenHeight * 0.488)
                    .padding(.leading, screenWidth * 0.85)
                }
            }
            if viewModel.showCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.green)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: viewModel.showCheckmark)
                    .position(x: screenWidth / 2, y: screenHeight * 0.5)
            }
        }
        .overlay {
            if viewModel.showFontMenu {
                FontMenuView(letter: $letter, showFontMenu: $viewModel.showFontMenu, fontViewModel: fontViewModel)
            }
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: viewModel.selectedItems) {
            Task { @MainActor in
                await viewModel.loadImages()
                letter.photoContents = viewModel.photoContents

                viewModel.showCheckmark = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    viewModel.showCheckmark = false
                }
            }
        }
        .onAppear {
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

// MARK: - ScrollableLetterView
struct ScrollableLetterView: View {
    @Binding var letter: WriteLetter
    @State private var scrollWorkItem: DispatchWorkItem?
    @ObservedObject var viewModel: ContentWriteViewModel
    
    var body: some View {
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
                    LazyHStack(alignment: .top, spacing: screenWidth * 0.04) {
                        ForEach(viewModel.texts.indices, id: \.self) { index in
                            TypingView(index: index, letter: $letter, viewModel: viewModel)
                                .onChange(of: viewModel.texts[index]) {
                                    letter.content = viewModel.texts
                                }
                                .padding(.top, 10)
                                .aspectRatio(9/13, contentMode: .fit)
                                .frame(width: screenWidth * 0.88)
                                .id(index)
                        }
                        
                        ForEach(viewModel.photoContents.indices, id: \.self) { index in
                            let imageIndex = index + viewModel.texts.count
                            if let uiImage = UIImage(data: viewModel.photoContents[index]) {
                                PolaroidView(index: imageIndex, uiImage: uiImage, letter: $letter, viewModel: viewModel)
                                    .frame(width: screenWidth * 0.88)
                                    .id(imageIndex)
                            }
                        }
                    }
                    .padding(.horizontal, screenWidth * 0.06)
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

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
