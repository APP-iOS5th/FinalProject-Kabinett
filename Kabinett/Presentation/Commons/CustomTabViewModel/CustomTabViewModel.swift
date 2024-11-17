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
    @Published var letterBoxNavigationPath = NavigationPath()
    @Published var profileNavigationPath = NavigationPath()
    @Published var isLetterWrite: Bool = false
    @Published var previousTab: Int?
    
    static let profileTabTappedNotification = Notification.Name("profileTabTapped")
    
    private var lastTabSelectionTime: Date?
    private let doubleTapInterval: TimeInterval = 0.2
    
    // MARK: TabView SystemImage Size
    let envelopeImage: UIImage
    let plusImage: UIImage
    let profileImage: UIImage
    
    init() {
        self.envelopeImage = UIImage(systemName: "envelope")!.applyingSymbolConfiguration(.init(pointSize: 21, weight: .medium))!
        self.plusImage = UIImage(systemName: "plus")!.applyingSymbolConfiguration(.init(pointSize: 24, weight: .medium))!
        self.profileImage = UIImage(systemName: "circle.fill")!.applyingSymbolConfiguration(.init(pointSize: 21, weight: .medium))!
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
    
    func handleTabSelection(_ tab: Int) {
        if tab == selectedTab {
            if tab == 2 {
                NotificationCenter.default.post(name: CustomTabViewModel.profileTabTappedNotification, object: nil)
            }
            if tab == 0 {
                letterBoxNavigationPath.removeLast(letterBoxNavigationPath.count)
            }
        } else if tab == 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                showOptions = true
            }
        } else {
            selectedTab = tab
        }
    }
    
    private func resetNavigationForTab(_ tab: Int) {
        switch tab {
        case 0:
            letterBoxNavigationPath.removeLast(letterBoxNavigationPath.count)
        case 2:
            profileNavigationPath.removeLast(profileNavigationPath.count)
        default:
            break
        }
    }
    
    func navigateToLetterBox() {
        selectedTab = 0
        showOptions = false
        showImportDialog = false
        showPhotoLibrary = false
        showCamera = false
        showImagePreview = false
        showWriteLetterView = false
    }
    
    // MARK: OptionOverlay sheet 관련 Method
    func hideOptions() {
        showOptions = false
    }
    
    func showImportDialogAndHideOptions() {
        showOptions = false
        showImportDialog = true
        isLetterWrite = false
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
    func calculateOptionOverlayBottomPadding() -> CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
        
        if safeAreaBottom > 0 {
            return safeAreaBottom + 20
        } else {
            return 55
        }
    }
    // MARK: OptionOverlay TabBar 위치 관련 Method
    func calculateYPosition(viewHeight: CGFloat, bottomSafeAreaHeight: CGFloat) -> CGFloat{
        
        if bottomSafeAreaHeight > 0 {
            return viewHeight / 2 - bottomSafeAreaHeight + 30
        } else {
            return viewHeight / 2 - bottomSafeAreaHeight - 15
        }
    }
}
