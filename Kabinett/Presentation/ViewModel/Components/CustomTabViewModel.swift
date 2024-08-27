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

    let tabs: [TabItem]

    init(tabs: [TabItem]) {
        self.tabs = tabs
    }

    static func defaultTabs() -> [TabItem] {
        [
            TabItem(imageName: "envelope", size: 21),
            TabItem(imageName: "plus", size: 24),
            TabItem(imageName: "person.crop.circle", size: 21)
        ]
    }
}

struct TabItem: Identifiable {
    let id = UUID()
    let imageName: String
    let size: CGFloat
}
