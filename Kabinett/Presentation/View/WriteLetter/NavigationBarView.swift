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

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color("ContentPrimary"))
                .contentShape(Rectangle())
        }
        .padding(.leading, UIScreen.main.bounds.width * 0.02)
    }
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
