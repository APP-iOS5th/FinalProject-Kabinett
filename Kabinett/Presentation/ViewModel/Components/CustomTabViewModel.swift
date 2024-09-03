//
//  CustomTabViewModel.swift
//  Kabinett
//
//  Created by 김정우 on 8/26/24.
//

import SwiftUI

final class CustomTabViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var showOptions: Bool = false
    @Published var showImportDialog: Bool = false
    @Published var showCamera: Bool = false
    @Published var showPhotoLibrary: Bool = false
    @Published var showImagePreview: Bool = false
    @Published var showWriteLetterView: Bool = false
    @Published var safeAreaBottom: CGFloat = 0
    
    @Published var letterWrite: Bool = false
    
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
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = blurEffect
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.01)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.05)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // MARK: OptionOverlay sheet 관련 Method
    func hideOptions() {
        showOptions = false
    }
    
    func showImportDialogAndHideOptions() {
        showOptions = false
        showImportDialog = true
    }
    
    func showWriteLetterViewAndHideOptions() {
        showOptions = false
        showWriteLetterView = true
    }
    
    // MARK: ImagePicker sheet 관련 Method
    func togglePhotoLibrary() {
        showPhotoLibrary.toggle()
    }
    
    func toggleImagePreview() {
        showImagePreview.toggle()
    }
    
    func toggleImportDialog() {
        showImportDialog.toggle()
    }
    
    // MARK: OptionOverlay Button 위치 관련 Method
    func getSafeAreaBottom(additionalPadding: CGFloat = 25) -> CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
        return safeAreaBottom + additionalPadding
    }
    
}
