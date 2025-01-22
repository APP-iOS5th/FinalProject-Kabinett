//
//  CustomTextEditor.swift
//  Kabinett
//
//  Created by Song Kim on 1/6/25.
//

import UIKit
import SwiftUI

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    var maxWidth: CGFloat
    var maxHeight: CGFloat
    var font: UIFont
    @Binding var currentHeight: CGFloat
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let size = textView.sizeThatFits(CGSize(width: parent.maxWidth, height: CGFloat.greatestFiniteMagnitude))
            
            parent.currentHeight = size.height
            
            if size.height > parent.maxHeight {
                textView.text = parent.text
            } else {
                parent.text = textView.text
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
        textView.font = font
        
        let maxWidthConstraint = NSLayoutConstraint(
            item: textView,
            attribute: .width,
            relatedBy: .lessThanOrEqual,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: maxWidth
        )
        textView.addConstraint(maxWidthConstraint)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        uiView.font = font
    }
}
