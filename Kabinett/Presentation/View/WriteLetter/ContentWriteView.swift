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

struct ContentWriteView: View {
    @Binding var letterContent: LetterWriteModel
    @StateObject var viewModel = ContentWriteViewModel()
    @ObservedObject var imageViewModel: ImagePickerViewModel
    @ObservedObject var customTabViewModel: CustomTabViewModel
    
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
            
            VStack {
                HStack(alignment: .center) {
                    Button {
                        if viewModel.texts.count > 1 {
                            viewModel.isDeleteAlertPresented = true
                        }
                    } label: {
                        Image("PageMinus")
                            .font(.system(size: 15))
                            .frame(width: UIScreen.main.bounds.width * 0.3/3)
                    }
                    .alert(isPresented: $viewModel.isDeleteAlertPresented) {
                        Alert(
                            title: Text("Delete Page"),
                            message: Text("현재 페이지를 삭제하시겠습니까?"),
                            primaryButton: .destructive(Text("삭제")) {
                                viewModel.deleteLetter(idx: viewModel.currentIndex)
                            },
                            secondaryButton: .cancel(Text("취소")) {
                                viewModel.isDeleteAlertPresented = false
                            }
                        )
                    }
                    Button {
                        viewModel.createNewLetter(idx: viewModel.currentIndex)
                    } label: {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 15))
                            .frame(width: UIScreen.main.bounds.width * 0.3/3)
                    }
                    Button {
                        customTabViewModel.showPhotoLibrary = true
                        customTabViewModel.isLetterWrite = true
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 15))
                            .frame(width: UIScreen.main.bounds.width * 0.3/3, height: 30)
                            .background(letterContent.photoContents.isEmpty ? Color.clear : Color.white)
                            .foregroundStyle(letterContent.photoContents.isEmpty ? Color("ToolBarIcon") : Color(.primary900))
                            .clipShape(Capsule())
                            .shadow(color: letterContent.photoContents.isEmpty ? Color.clear : Color(.primary300), radius: 5, x: 3, y: 3)
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.45, maxHeight: 40)
                .foregroundStyle(Color("ToolBarIcon"))
                .background(Color(.primary100))
                .clipShape(Capsule())
                .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
                .padding(.top, 35)

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
    }
}


// MARK: - ScrollableLetterView
struct ScrollableLetterView: View {
    @Binding var letterContent: LetterWriteModel
    @ObservedObject var viewModel: ContentWriteViewModel
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
                                            .padding(.top, 10)
                                        
                                        VStack {
                                            HStack {
                                                Text(i == 0 ? letterContent.toUserName : "")
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .onTapGesture {
                                                        UIApplication.shared.endEditing()
                                                    }
                                                Spacer()
                                            }
                                            .padding(.top, 45)
                                            .padding(.leading, 2)
                                            .padding(.bottom, 3)
                                            
                                            GeometryReader { geo in
                                                CustomTextEditor(
                                                    text: $viewModel.texts[i],
                                                    maxWidth: geo.size.width,
                                                    maxHeight: geo.size.height,
                                                    font: FontUtility.selectedUIFont(font: letterContent.fontString ?? "", size: FontUtility.fontSize(font: letterContent.fontString ?? "")),
                                                    lineSpacing: FontUtility.lineSpacing(font: letterContent.fontString ?? ""),
                                                    kerning: FontUtility.kerning(font: letterContent.fontString ?? "")
                                                )
                                            }
                                            .onChange(of: viewModel.texts[i]) {
                                                letterContent.content = viewModel.texts
                                            }
                                            .onChange(of: viewModel.texts.count) {
                                                letterContent.content = viewModel.texts
                                            }
                                            
                                            Text(i == (viewModel.texts.count-1) ? (letterContent.date).formattedString() : "")
                                                .padding(.trailing, 2)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                            
                                            Text(i == (viewModel.texts.count-1) ? letterContent.fromUserName : "")
                                                .padding(.bottom, 30)
                                                .padding(.trailing, 2)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                        .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
                                    }
                                    .aspectRatio(9/13, contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.width * 0.88)
                                    .id(i)
                                    Spacer()
                                        .anchorPreference(key: AnchorsKey.self, value: .trailing, transform: { [i: $0] })
                                }
                            }
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .font(FontUtility.selectedFont(font: letterContent.fontString ?? "", size: 15))
                .onChange(of: viewModel.texts.count) {
                    withAnimation {
                        scrollViewProxy.scrollTo((currentIndex+1), anchor: .center)
                    }
                }
                .onPreferenceChange(AnchorsKey.self) { anchors in
                    let leadingAnchor = anchors
                        .filter { geometry[$0.value].x >= 0 }
                        .sorted { geometry[$0.value].x < geometry[$1.value].x }
                        .first
                    
                    if currentIndex != leadingAnchor?.key ?? 0 {
                        currentIndex = leadingAnchor?.key ?? 0
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


// MARK: - CustomTextEditor.swift
struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    var maxWidth: CGFloat
    var maxHeight: CGFloat
    var font: UIFont
    var lineSpacing: CGFloat
    var kerning: CGFloat
    
    let maxCharacterLimit: Int = 427
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            if textView.text.count > parent.maxCharacterLimit {
                textView.text = String(textView.text.prefix(parent.maxCharacterLimit))
            }
            
            parent.text = textView.text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.smartInsertDeleteType = .no
        
        let maxWidthConstraint = NSLayoutConstraint(item: textView,
                                                    attribute: .width,
                                                    relatedBy: .lessThanOrEqual,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: maxWidth)
        textView.addConstraint(maxWidthConstraint)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text == text && uiView.font == font {
            return
        }
        
        uiView.attributedText = createAttributedString(text: text, font: font, lineSpacing: lineSpacing, kerning: kerning)
    }
    
    private func createAttributedString(text: String, font: UIFont, lineSpacing: CGFloat, kerning: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: kerning,
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
