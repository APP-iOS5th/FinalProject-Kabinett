//
//  CustomTabViewModel.swift
//  Kabinett
//
//  Created by 김정우 on 8/26/24.
//

import SwiftUI

class CustomTabViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var showOptions: Bool = false
    @Published var showActionSheet: Bool = false
    @Published var showCamera: Bool = false
    @Published var showPhotoLibrary: Bool = false
    @Published var showImagePreview: Bool = false
    @Published var showWriteLetterView: Bool = false
    
    // MARK: TabView SystemImage Size
    let envelopeImage: UIImage
    let plusImage: UIImage
    let profileImage: UIImage
    
    init() {
        self.envelopeImage = UIImage(systemName: "envelope")!.applyingSymbolConfiguration(.init(pointSize: 21, weight: .medium))!
        self.plusImage = UIImage(systemName: "plus")!.applyingSymbolConfiguration(.init(pointSize: 24, weight: .medium))!
        self.profileImage = UIImage(systemName: "person.crop.circle")!.applyingSymbolConfiguration(.init(pointSize: 21, weight: .medium))!
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = UIScreen.main.bounds
        
        appearance.backgroundEffect = blurEffect
        
        appearance.backgroundColor = UIColor.clear
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.01)
        
        
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.05)
        
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color("Primary300"))
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color("Primary600"))
        
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UITabBar.centerTabItems()
    }
    
}

// MARK: tabview items Y 축 중앙 위치
extension UITabBar {
    static func centerTabItems() {
        UITabBar.appearance().itemPositioning = .centered
        
        if let originalMethod = class_getInstanceMethod(UITabBar.self, #selector(layoutSubviews)),
           let swizzledMethod = class_getInstanceMethod(UITabBar.self, #selector(swizzled_layoutSubviews)) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    @objc func swizzled_layoutSubviews() {
        swizzled_layoutSubviews()
        let centerY = self.bounds.height / 2
        
        self.subviews.forEach { subview in
            if let itemView = subview as? UIControl {
                var center = itemView.center
                center.y = centerY
                itemView.center = center
            }
        }
    }
}
