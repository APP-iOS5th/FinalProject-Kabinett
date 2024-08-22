//
//  WriteLetterView.swift
//  Kabinett
//
//  Created by Song Kim on 8/21/24.
//

import SwiftUI
import UIKit

// MARK: WriteLetterView
struct WriteLetterView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var textViewHeight: CGFloat = .zero
    @ObservedObject var viewModel = FontSelectionViewModel()
    
    @State var arr: [String] = [""]
    @State var text: String = ""
    
    @State var sizeCheck = true
    @State var geoHeight: CGFloat = .zero
    @State var geoWidth: CGFloat = .zero
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    NavigationBarView(destination: ModalTestView(), titleName: "")
                        .onAppear {
                            if sizeCheck {
                                sizeCheck = false
                                geoHeight = geometry.size.height * 0.4
                                geoWidth = geometry.size.width * 0.06
                            }
                        }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<arr.count, id: \.self) { i in
                                LetterWriteContext(
                                    letterContent: $letterContent,
                                    arr: $arr,
                                    text: $arr[i],
                                    textViewHeight: $textViewHeight,
                                    viewModel: viewModel,
                                    geoHeight: geoHeight,
                                    geoWidth: geoWidth
                                )
                                .frame(height: geoHeight + 150)
                            }
                        }
                        .padding(2)
                    }
                }
                .padding(.horizontal, geoWidth)
            }
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .padding()
        }
    }
}

// MARK: LetterWriteContext
struct LetterWriteContext: View {
    @Binding var letterContent: LetterWriteViewModel
    @Binding var arr: [String]
    @Binding var text: String
    
    @Binding var textViewHeight: CGFloat
    @ObservedObject var viewModel: FontSelectionViewModel
    
    let geoHeight: CGFloat
    let geoWidth: CGFloat
    
    var body: some View {
        VStack {
            ZStack {
                AsyncImage(url: URL(string: letterContent.stationeryImageUrlString ?? "")) { image in
                    image
                        .resizable()
                        .shadow(radius: 5, x: 5, y: 5)
                        .padding(.top, 10)
                } placeholder: {
                    ProgressView()
                }
                
                VStack {
                    CustomTextEditor(text: $text, height: $textViewHeight)
                        .onChange(of: text) {
                            if textViewHeight > geoHeight {
                                arr.append("")
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(8/9, contentMode: .fit)
                .padding(.horizontal, geoWidth)
                
                VStack {
                    Text(letterContent.fromUserName)
                        .padding(.top, 50)
                        .padding(.leading, 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text(letterContent.toUserName)
                        .padding(.trailing, 2)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text(formatDate(letterContent.date))
                        .padding(.bottom, 30)
                        .padding(.trailing, 2)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, geoWidth)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .aspectRatio(9/13, contentMode: .fit)
            .font(viewModel.font(file: letterContent.fontString ?? "SFDisplay"))
        }
        
    }
}

// MARK: CustomTextEditor
struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.height = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
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
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.sizeToFit()
    }
}

private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, yyyy"
    return formatter.string(from: date)
}


#Preview {
    ModalTestView()
}
