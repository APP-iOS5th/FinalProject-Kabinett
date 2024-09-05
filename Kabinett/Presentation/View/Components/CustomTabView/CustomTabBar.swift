//
//  CustomTabBar.swift
//  Kabinett
//
//  Created by 김정우 on 8/28/24.
//

import SwiftUI

struct CustomTabBar: View {
    @EnvironmentObject var viewModel: CustomTabViewModel

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                tabItem(image: viewModel.envelopeImage, tag: 0)
                    .frame(width: geometry.size.width / 3)
                tabItem(image: viewModel.plusImage, tag: 1)
                    .frame(width: geometry.size.width / 3)
                tabItem(image: viewModel.profileImage, tag: 2)
                    .frame(width: geometry.size.width / 3)
            }
            .frame(width: geometry.size.width, height: 44)
            .background(Color.clear)
            .position(x: geometry.size.width / 2, y: calculateYPosition(geometry: geometry))
        }
    }
    
    private func calculateYPosition(geometry: GeometryProxy) -> CGFloat {
        let basePosition: CGFloat = geometry.size.height - 22
        let bottomSafeAreaHeight = geometry.safeAreaInsets.bottom
        
        if bottomSafeAreaHeight > 0 {
            return basePosition - bottomSafeAreaHeight + 15
        } else {
            return basePosition - 10
        }
    }
    
    private func tabItem(image: UIImage, tag: Int) -> some View {
        Button(action: {
            viewModel.handleTabSelection(tag)
        }) {
            Image(uiImage: image)
                .renderingMode(.template)
                .foregroundStyle(viewModel.selectedTab == tag ? Color.primary600 : Color.primary300)
        }
    }
}
