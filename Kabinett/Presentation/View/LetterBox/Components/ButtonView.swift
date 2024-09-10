//
//  ButtonView.swift
//  Kabinett
//
//  Created by uunwon on 9/10/24.
//

import SwiftUI

struct BeforeButtonView: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
        Button(action: {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.contentPrimary)
                .padding(.leading, 4)
        }
        .padding()
        .opacity(selectedIndex > 0 ? 1 : 0)
    }
}

struct CloseButtonView: View {
    var dismiss: () -> Void
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.contentPrimary)
                .padding(.trailing, 4)
        }
        .padding()
    }
}
