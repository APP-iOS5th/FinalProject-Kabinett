//
//  NavigationBarView.swift
//  Kabinett
//
//  Created by Song Kim on 8/21/24.
//

import SwiftUI

struct NavigationBarView<ToolbarContent: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let titleName: String
    let isColor: Bool
    let toolbarContent: ToolbarContent
    
    init(titleName: String, isColor: Bool, @ViewBuilder toolbarContent: () -> ToolbarContent) {
        self.titleName = titleName
        self.isColor = isColor
        self.toolbarContent = toolbarContent()
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color("ContentPrimary"))
                }
                Spacer()
            }
            
            Text(titleName)
                .font(.system(size: 16, weight: .semibold))
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            HStack {
                Spacer()
                toolbarContent
            }
        }
        .padding(.top, 12)
        .background(isColor ? .background : .clear)
    }
}
