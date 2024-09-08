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
    let backAction: (() -> Void)?
    
    init(titleName: String, isColor: Bool, @ViewBuilder toolbarContent: () -> ToolbarContent, backAction: (() -> Void)? = nil) {
        self.titleName = titleName
        self.isColor = isColor
        self.toolbarContent = toolbarContent()
        self.backAction = backAction
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    if let backAction = backAction {
                        backAction()
                    }
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
