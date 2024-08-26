//
//  TabBarButton.swift
//  Kabinett
//
//  Created by 김정우 on 8/23/24.
//

import SwiftUI

struct TabBarButton: View {
    let imageName: String
    let isSelected: Bool
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .foregroundColor(isSelected ? Color("Primary600") : Color("Primary300"))
        }
        .frame(maxWidth: .infinity)
    }
}
