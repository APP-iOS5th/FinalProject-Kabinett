//
//  CustomTabBar.swift
//  Kabinett
//
//  Created by 김정우 on 8/28/24.
//

import SwiftUI

struct CustomTabBar: View {
    @ObservedObject var viewModel: CustomTabViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                tabItem(image: viewModel.envelopeImage, tag: 0)
                    .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.5)
                
                tabItem(image: viewModel.plusImage, tag: 1)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                
                tabItem(image: viewModel.profileImage, tag: 2)
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.5)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .frame(height: 20)
    }
    
    private func tabItem(image: UIImage, tag: Int) -> some View {
        Button(action: {
            viewModel.selectedTab = tag
        }) {
            Image(uiImage: image)
                .renderingMode(.template)
                .foregroundStyle(viewModel.selectedTab == tag ? Color.primary600 : Color.primary300)
        }
    }
}
