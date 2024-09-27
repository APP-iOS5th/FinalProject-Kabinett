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
    @EnvironmentObject var viewModel: ContentWriteViewModel
    @EnvironmentObject var imageViewModel: ImagePickerViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.background).ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                NavigationBarView(titleName: "", isColor: true) {
                    NavigationLink(destination: EnvelopeStampSelectionView(letterContent: $letterContent)) {
                        Text("다음")
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundStyle(.contentPrimary)
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                
                ScrollableLetterView(letterContent: $letterContent)
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
        .slideToDismiss() // 스크롤 부분이라 어색함.
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
    @EnvironmentObject var viewModel: ContentWriteViewModel
    @EnvironmentObject var customViewModel: CustomTabViewModel
    @EnvironmentObject var fontViewModel: FontSelectionViewModel
    
    var body: some View {
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
                                            
                                            Button {
                                                customViewModel.showPhotoLibrary = true
                                                customViewModel.isLetterWrite = true
                                            } label: {
                                                Image(systemName: "photo.on.rectangle.angled")
                                                    .font(.system(size: 15))
                                                    .padding(.horizontal, 13)
                                                    .padding(.vertical, 8)
                                                    .foregroundStyle(letterContent.photoContents.isEmpty ? Color(.primary900) : Color.white)
                                                    .background(letterContent.photoContents.isEmpty ? Color(.primary300) : Color(.primary900))
                                                    .clipShape(Capsule())
                                            }
                                            
                                        }
                                        .padding(.top, 45)
                                        .padding(.leading, 2)
                                        .padding(.bottom, 3)
                                        
                                        GeometryReader { geo in
                                            CustomTextEditor(text: $viewModel.texts[i],
                                                             height: $viewModel.textViewHeights[i],
                                                             maxWidth: geo.size.width,
                                                             maxHeight: geo.size.height,
                                                             font: fontViewModel.selectedUIFont(font: letterContent.fontString ?? "",
                                                                                                size: {
                                                if letterContent.fontString == "SourceHanSerifK-Regular" {
                                                    return (UIScreen.main.bounds.width * 0.0333)
                                                } else if letterContent.fontString == "NanumMyeongjoOTF" {
                                                    return (UIScreen.main.bounds.width * 0.0392)
                                                } else if letterContent.fontString == "Baskervville-Regular" {
                                                    return (UIScreen.main.bounds.width * 0.0369)
                                                } else if letterContent.fontString == "Pecita" {
                                                    return (UIScreen.main.bounds.width * 0.037)
                                                } else {
                                                    return (UIScreen.main.bounds.width * 0.0382)
                                                }
                                            }()),
                                                             lineSpacing: {
                                                if letterContent.fontString == "Pecita" {
                                                    return (UIScreen.main.bounds.width * 0.0069)
                                                } else if letterContent.fontString == "SFDisplay" {
                                                    return (UIScreen.main.bounds.width * 0.0013)
                                                } else if letterContent.fontString == "goormSansOTF4" {
                                                    return (UIScreen.main.bounds.width * 0.0013)
                                                }  else if letterContent.fontString == "Baskervville-Regular" {
                                                    return (UIScreen.main.bounds.width * 0.002)
                                                } else {
                                                    return 0.0
                                                }
                                            }(),
                                                             kerning: {
                                                if letterContent.fontString == "SFMONO" {
                                                    return -(UIScreen.main.bounds.width * 0.0025)
                                                } else if letterContent.fontString == "SFDisplay" {
                                                    return (UIScreen.main.bounds.width * 0.0005)
                                                } else if letterContent.fontString == "goormSansOTF4" {
                                                    return (UIScreen.main.bounds.width * 0.001)
                                                } else {
                                                    return 0.0
                                                }
                                            }()
                                            )
                                            .onChange(of: viewModel.textViewHeights[i]) {
                                                if viewModel.textViewHeights[i] >= geo.size.height {
                                                    viewModel.createNewLetter()
                                                }
                                            }
                                            .onChange(of: viewModel.texts[i]) {  //일단 한 페에지만 구현
                                                if letterContent.content.isEmpty {
                                                    letterContent.content.append("")
                                                }
                                                letterContent.content[0] = viewModel.texts[0]
                                            }
                                            .onAppear {
                                                print(UIScreen.main.bounds.width)
                                            }
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
                            }
                        }
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .font(fontViewModel.selectedFont(font: letterContent.fontString ?? "", size: 15))
            .onChange(of: viewModel.texts.count) {
                withAnimation {
                    viewModel.currentIndex = viewModel.texts.count - 1
                    scrollViewProxy.scrollTo(viewModel.currentIndex, anchor: .center)
                }
            }
        }
    }
}


// MARK: - CustomTextEditor.swift
struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    var maxWidth: CGFloat
    var maxHeight: CGFloat
    var font: UIFont
    var lineSpacing: CGFloat  // Line height
    var kerning: CGFloat  // Letter spacing (kerning)
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let newSize = textView.sizeThatFits(CGSize(width: parent.maxWidth, height: CGFloat.greatestFiniteMagnitude))
            
            if newSize.height <= parent.maxHeight {
                parent.text = textView.text
                DispatchQueue.main.async {
                    self.parent.height = newSize.height
                }
            } else {
                textView.text = parent.text
            }
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
        
        let newSize = uiView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        DispatchQueue.main.async {
            if newSize.height <= maxHeight {
                self.height = newSize.height
            }
        }
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