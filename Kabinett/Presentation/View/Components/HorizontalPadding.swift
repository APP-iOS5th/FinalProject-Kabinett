//
//  HorizontalPadding.swift
//  Kabinett
//
//  Created by 김정우 on 8/25/24.
//

import SwiftUI

struct HorizontalPadding: ViewModifier {
    @State private var padding: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.horizontal, geometry.size.width * 0.06)
                .onAppear {
                    padding = geometry.size.width * 0.06
                }
        }
    }
}

extension View {
    func horizontalPadding() -> some View {
        self.modifier(HorizontalPadding())
    }
}
