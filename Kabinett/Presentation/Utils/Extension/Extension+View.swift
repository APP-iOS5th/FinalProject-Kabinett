//
//  Extension+View.swift
//  Kabinett
//
//  Created by Song Kim on 9/7/24.
//

import SwiftUI

extension View {
    func slideToDismiss(threshold: CGFloat = 100, action: @escaping () -> Void = {}) -> some View {
        self.modifier(SlideToDismissModifier(threshold: threshold, action: action))
    }
}

struct SlideToDismissModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    @State private var offset = CGSize.zero
    var threshold: CGFloat = 100
    var action: () -> Void

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            Color(.background).ignoresSafeArea()
            
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
                                action()
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
