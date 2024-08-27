//
//  WirteLetter.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import SwiftUI
import UIKit

struct WriteLetterView: View {
    @Binding var letterContent: LetterWriteViewModel
    @StateObject private var viewModel = WriteLetterViewModel()
    @ObservedObject private var fontViewModel = FontSelectionViewModel()
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    NavigationBarView(destination: EnvelopeStampSelectionView(letterContent: $letterContent), titleName: "")
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                    
                    HStack {
                        ScrollViewReader { scrollViewProxy in
                            ZStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: geometry.size.width * 0.04) {
                                        ForEach(0..<viewModel.texts.count, id: \.self) { i in
                                            ZStack {
                                                // 편지지 이미지 뷰
                                                AsyncImage(url: URL(string: letterContent.stationeryImageUrlString ?? "")) { image in
                                                    image
                                                        .resizable()
                                                        .shadow(radius: 5, x: 5, y: 5)
                                                        .padding(.top, 10)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                
                                                // 편지지 위의 뷰
                                                VStack {
                                                    Text(i == 0 ? letterContent.fromUserName : "")
                                                        .padding(.top, 45)
                                                        .padding(.leading, 2)
                                                        .padding(.bottom, 3)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    GeometryReader { geo in
                                                        CustomTextEditor(text: $viewModel.texts[i], 
                                                                         height: $viewModel.textViewHeights[i],
                                                                         maxWidth: geo.size.width,
                                                                         maxHeight: UIScreen.main.bounds.height * 0.42,
                                                                         font: UIFont(name: letterContent.fontString ?? "", size: 13) ?? UIFont.systemFont(ofSize: 13))
                                                            .onChange(of: viewModel.textViewHeights[i]) {
                                                                if viewModel.textViewHeights[i] >= UIScreen.main.bounds.height * 0.42 {
                                                                    viewModel.createNewLetter()
                                                                }
                                                            }
                                                            .onChange(of: viewModel.texts[i]) {  //일단 한 페에지만 구현
                                                                letterContent.content = viewModel.texts[0]
                                                            }
                                                    }
                                                    
                                                    Text(i == (viewModel.texts.count-1) ? letterContent.toUserName : "")
                                                        .padding(.top, 2)
                                                        .padding(.trailing, 2)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                    
                                                    Text(i == (viewModel.texts.count-1) ? viewModel.formatDate(letterContent.date) : "")
                                                        .padding(.bottom, 27)
                                                        .padding(.trailing, 2)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                }
                                                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                                                
                                            }
                                            .aspectRatio(9/13, contentMode: .fit)
                                            .frame(width: UIScreen.main.bounds.width * 0.88)
                                            .id(i)
                                        }
                                    }
                                    .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .frame(height: geometry.size.height * 0.7)
                            .font(fontViewModel.font(file: letterContent.fontString ?? "SFDisplay"))
                            .onChange(of: viewModel.texts.count) {
                                withAnimation {
                                    currentIndex = viewModel.texts.count - 1
                                    scrollViewProxy.scrollTo(currentIndex, anchor: .center)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
    }
}


// MARK: CustomTextEditor.swift
import SwiftUI

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
