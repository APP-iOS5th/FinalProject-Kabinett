//
//  CustomTabBar.swift
//  Kabinett
//
//  Created by 김정우 on 8/23/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showOptions: Bool
    var body: some View {
        HStack {
            TabBarButton(imageName: "envelope", isSelected: selectedTab == 0, size: 21) {
                selectedTab = 0
            }
            
            TabBarButton(imageName: "plus", isSelected: false, size: 24) {
                withAnimation {
                    showOptions = true
                }
            }
            
            TabBarButton(imageName: "person.crop.circle", isSelected: selectedTab == 2, size: 21) {
                selectedTab = 2
            }
        }
        .frame(height: 60)
        .background(Color("Background").edgesIgnoringSafeArea(.bottom))
    }
}
