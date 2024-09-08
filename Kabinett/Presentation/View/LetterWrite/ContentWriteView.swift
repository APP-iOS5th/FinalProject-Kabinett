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
                
                ScrollableLetterView(letterContent: $letterContent)
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
        .overlay(
            ImagePickerView()
        )
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
                                            Image(systemName: "arrow.down.circle.dotted")
                                        }
                                        .resizable()
                                        .shadow(color: Color(.primary300), radius: 5, x: 5, y: 5)
                                        .padding(.top, 10)
                                    
                                    VStack {
                                        HStack {
                                            Text(i == 0 ? letterContent.fromUserName : "")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .onTapGesture {
                                                    UIApplication.shared.endEditing()
                                                }
                                            Spacer()
                                            
                                            Button {
                                                customViewModel.showPhotoLibrary = true
                                                customViewModel.letterWrite = true
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
                                                             font: viewModel.selectedFont(font: letterContent.fontString ?? ""))
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
                                        }
                                        Text(i == (viewModel.texts.count-1) ? (letterContent.date).formattedString() : "")
                                            .padding(.trailing, 2)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                        
                                        Text(i == (viewModel.texts.count-1) ? letterContent.toUserName : "")
                                            .padding(.bottom, 30)
                                            .padding(.trailing, 2)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                                    
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
            .font(.custom(letterContent.fontString ?? "SFDisplay", size: 15))
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
        textView.font = font
        
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
        uiView.text = text
        uiView.font = font
        
        let newSize = uiView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        DispatchQueue.main.async {
            if newSize.height <= maxHeight {
                self.height = newSize.height
            }
        }
    }
}
