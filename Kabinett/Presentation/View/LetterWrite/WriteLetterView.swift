//
//  WirteLetter.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import SwiftUI

struct WriteLetterView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = WriteLetterViewModel()
    @ObservedObject private var fontViewModel = FontSelectionViewModel()
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    NavigationBarView(destination: WriteLetterView(letterContent: $letterContent), titleName: "")
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                    
                    HStack {
                        ScrollViewReader { scrollViewProxy in
                            ZStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: geometry.size.width * 0.04) {
                                        ForEach(0..<viewModel.pageCnt, id: \.self) { i in
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
                                                    Text(letterContent.fromUserName)
                                                        .padding(.top, 45)
                                                        .padding(.leading, 2)
                                                        .padding(.bottom, 5)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    GeometryReader{ geo in
                                                        VStack {
                                                            let pageText = viewModel.getPageText(for: i)
                                                            UITextViewWrapper(
                                                                text: Binding(
                                                                    get: { pageText },
                                                                    set: { newValue in
                                                                        viewModel.updateText(for: i, with: newValue)
                                                                    }
                                                                ),
                                                                font: fontViewModel.uiFont(file: letterContent.fontString ?? "")
                                                            )
                                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                            .aspectRatio(8/9, contentMode: .fit)
                                                        }
                                                    }
                                                    
                                                    Text(letterContent.toUserName)
                                                        .padding(.top, 5)
                                                        .padding(.trailing, 2)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                    
                                                    Text(viewModel.formatDate(letterContent.date))
                                                        .padding(.bottom, 27)
                                                        .padding(.trailing, 2)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                }
                                                
                                                .padding(.horizontal, 24)
                                            }
                                            .aspectRatio(9/13, contentMode: .fit)
                                            .frame(width: geometry.size.width * 0.88)
                                        }
                                    }
                                    .padding(.horizontal, geometry.size.width * 0.06)
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .frame(height: geometry.size.height * 0.7)
                            .font(fontViewModel.font(file: letterContent.fontString ?? "SFDisplay"))
                            .onChange(of: viewModel.pageCnt) {
                                withAnimation {
                                    scrollViewProxy.scrollTo(viewModel.pageCnt - 1, anchor: .center)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
        .onChange(of: viewModel.text) {
            viewModel.adjustPageCount()
        }
    }
}


// MARK: UITextViewWrapper
struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    var font: UIFont?
    var lineSpacing: CGFloat = 5
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewWrapper
        
        init(parent: UITextViewWrapper) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 12),
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        uiView.attributedText = attributedString
    }
}


#Preview {
    ModalTestView()
}
