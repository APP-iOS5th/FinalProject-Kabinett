//
//  Extension+TextField.swift
//  Kabinett
//
//  Created by Song Kim on 8/27/24.
//

import Foundation
import SwiftUI

struct MaxLengthModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > maxLength {
                    text = oldValue
                }
            }
    }
}

extension TextField {
    func maxLength(text: Binding<String>, _ maxLength: Int) -> some View {
        return ModifiedContent(content: self,
                               modifier: MaxLengthModifier(text: text,
                                                           maxLength: maxLength))
    }
}
