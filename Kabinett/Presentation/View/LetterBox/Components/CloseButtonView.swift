//
//  CloseButtonView.swift
//  Kabinett
//
//  Created by uunwon on 9/10/24.
//

import SwiftUI

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
