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

struct ContentWriteView: View {
    @Binding var letterContent: LetterWriteModel
    @StateObject var viewModel = ContentWriteViewModel()
    @ObservedObject var imageViewModel: ImagePickerViewModel
    @ObservedObject var customTabViewModel: CustomTabViewModel
    @StateObject var fontViewModel = FontSelectionViewModel()
    
    @State var isPopup: Bool = false
    
    init(
        letterContent: Binding<LetterWriteModel>,
        imageViewModel: ImagePickerViewModel,
        customTabViewModel: CustomTabViewModel
    ) {
        @Injected(ImportLetterUseCaseKey.self) var importLetterUseCase: ImportLetterUseCase
        self._letterContent = letterContent
        self.imageViewModel = imageViewModel
        self.customTabViewModel = customTabViewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.background).ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            ZStack(alignment: .top) {
                VStack {
                    ScrollableLetterView(letterContent: $letterContent, viewModel: viewModel, imageViewModel: imageViewModel, currentIndex: $viewModel.currentIndex)
                        .font(FontUtility.selectedFont(font: letterContent.fontString ?? "", size: 13))
                    
                    Text("\(viewModel.currentIndex+1) / \(viewModel.texts.count+imageViewModel.photoContents.count)")
                        .padding(5)
                        .padding(.horizontal, 8)
                        .background(Color(.primary900).opacity(0.3))
                        .clipShape(Capsule())
                }
                MiniTabBar(letterContent: $letterContent, viewModel: viewModel, customTabViewModel: customTabViewModel, isPopup: $isPopup)
            }
        }
        .overlay {
            if isPopup {
                CustomFontMenu(letterContent: $letterContent, isPopup: $isPopup, fontViewModel: fontViewModel)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: EnvelopeStampSelectionView(
                    letterContent: $letterContent,
                    customTabViewModel: customTabViewModel,
                    imageViewModel: imageViewModel
                )) {
                    Text("다음")
                        .fontWeight(.medium)
                        .font(.system(size: 19))
                        .foregroundStyle(.contentPrimary)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: imageViewModel.selectedItems) { _, newValue in
            Task { @MainActor in
                imageViewModel.selectedItems = newValue
                await imageViewModel.loadImages()
                letterContent.photoContents = imageViewModel.photoContents
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
}

// MARK: ScrollableLetterView
struct ScrollableLetterView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @Binding var letterContent: LetterWriteModel
    @ObservedObject var viewModel: ContentWriteViewModel
    @ObservedObject var imageViewModel: ImagePickerViewModel
    @Binding var currentIndex: Int
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollViewProxy in
                ZStack(alignment: .top) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: UIScreen.main.bounds.width * 0.04) {
                            ForEach(0..<viewModel.texts.count, id: \.self) { i in
                                VStack {
                                    ZStack {
                                        KFImage(URL(string: letterContent.stationeryImageUrlString ?? ""))
                                            .placeholder {
                                                ProgressView()
                                            }
                                            .resizable()
                                            .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
                                        
                                        VStack {
                                            Text(i == 0 ? letterContent.toUserName : "")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, screenHeight * 0.05)
                                                .padding(.bottom, screenHeight * 0.01)
                                                .onTapGesture {
                                                    UIApplication.shared.endEditing()
                                                }
                                            
                                            GeometryReader { geo in
                                                CustomTextEditor(
                                                    text: $viewModel.texts[i],
                                                    maxWidth: geo.size.width,
                                                    maxHeight: geo.size.height,
                                                    font: FontUtility.selectedUIFont(font: letterContent.fontString ?? "", size: FontUtility.fontSize(font: letterContent.fontString ?? ""))
                                                    //lineSpacing: FontUtility.lineSpacing(font: letterContent.fontString ?? ""),
                                                    //kerning: FontUtility.kerning(font: letterContent.fontString ?? "")
                                                )
                                            }
                                            .onChange(of: viewModel.texts[i]) {
                                                letterContent.content = viewModel.texts
                                            }
                                            .onChange(of: viewModel.texts.count) {
                                                letterContent.content = viewModel.texts
                                            }
                                            
                                            Text(i == (viewModel.texts.count-1) ? (letterContent.date).formattedString() : "")
                                                .padding(.bottom, screenHeight * 0.00001)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                            
                                            Text(i == (viewModel.texts.count-1) ? letterContent.fromUserName : "")
                                                .padding(.bottom, screenHeight * 0.05)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                        .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
                                    }
                                    .padding(.top, 10)
                                    .aspectRatio(9/13, contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.width * 0.88)
                                    .id(i)
                                    .anchorPreference(key: AnchorsKey.self, value: .trailing, transform: { [i: $0] })
                                    
                                    Spacer()
                                }
                            }

                            ForEach(0..<imageViewModel.photoContents.count, id: \.self) { index in
                                let imageIndex = index + viewModel.texts.count
                                if let uiImage = UIImage(data: imageViewModel.photoContents[index]) {
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.horizontal, 10)
                                            .padding(.top, 10)
                                            .padding(.bottom, UIScreen.main.bounds.width * 0.12)
                                            .background(Color.white)
                                            .frame(width: UIScreen.main.bounds.width * 0.88)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .padding(.top, 10)
                                            .tag(imageIndex)
                                            .anchorPreference(key: AnchorsKey.self, value: .trailing, transform: { [imageIndex: $0] })
                                        
                                        Button(action: {
                                            imageViewModel.photoContents.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .padding(.trailing, -5)
                                                .foregroundColor(Color(.primary900))
                                        }
                                    }
                                }
                            }

                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .onChange(of: viewModel.texts.count) {
                    withAnimation {
                        scrollViewProxy.scrollTo((currentIndex+1), anchor: .center)
                    }
                }
                .onPreferenceChange(AnchorsKey.self) { anchors in
                    let horizontalPadding = UIScreen.main.bounds.width * 0.06
                    let leadingAnchor = anchors
                        .filter { geometry[$0.value].x >= horizontalPadding }
                        .sorted { geometry[$0.value].x < geometry[$1.value].x }
                        .first

                    if let leadingAnchor = leadingAnchor, currentIndex != leadingAnchor.key {
                        currentIndex = leadingAnchor.key
                    }
                }

            }
        }
    }
}

struct AnchorsKey: PreferenceKey {
    typealias Value = [Int: Anchor<CGPoint>]
    static var defaultValue: Value { [ : ] }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}
