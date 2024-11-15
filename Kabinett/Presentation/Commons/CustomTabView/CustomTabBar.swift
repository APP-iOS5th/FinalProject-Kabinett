//
//  CustomTabBar.swift
//  Kabinett
//
//  Created by 김정우 on 8/28/24.
//

import SwiftUI
import Kingfisher

struct CustomTabBar: View {
    @ObservedObject var viewModel: CustomTabViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                tabItem(image: viewModel.envelopeImage, tag: 0)
                    .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.5)
                
                tabItem(image: viewModel.plusImage, tag: 1)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                
                profileTabItem(tag: 2)
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.5)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .position(
                x: geometry.size.width / 2,
                y: viewModel.calculateYPosition(
                    viewHeight: geometry.size.height,
                    bottomSafeAreaHeight: geometry.safeAreaInsets.bottom
                )
            )
        }
        .frame(height: 20)
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
    
    private func profileTabItem(tag: Int) -> some View {
        Button(action: {
            viewModel.handleTabSelection(tag)
        }) {
            ZStack {
                if let image = profileViewModel.currentWriter.imageUrlString {
                    KFImage(URL(string: image))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(viewModel.selectedTab == tag ? Color.primary900 : Color.clear, lineWidth: 1.5)
                                .scaleEffect(1.15)
                        )
                } else {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.primary300)
                        .overlay(
                            Circle().stroke(viewModel.selectedTab == tag ? Color.primary900 : Color.clear, lineWidth: 1.5)
                                .scaleEffect(1.15)
                        )
                }
            }
        }
    }
}
