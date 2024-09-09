//
//  Extension+View.swift
//  Kabinett
//
//  Created by Song Kim on 9/7/24.
//

import SwiftUI

extension View {
    func slideToDismiss(threshold: CGFloat = 100) -> some View {
        self.modifier(SlideToDismissModifier(threshold: threshold))
    }
}

struct SlideToDismissModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    @State private var offset = CGSize.zero
    var threshold: CGFloat = 100

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            Color.clear
                .opacity(Double(1 - abs(offset.width) / UIScreen.main.bounds.width))
            
            content
                .offset(x: offset.width)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width > 0 {
                                offset = gesture.translation
                            }
                        }
                        .onEnded { _ in
                            if offset.width > threshold {
                                dismiss()
                            } else {
                                withAnimation {
                                    offset = .zero
                                }
                            }
                        }
                )
                .animation(.spring(), value: offset)
        }
        .transition(.move(edge: .leading))
    }
}
