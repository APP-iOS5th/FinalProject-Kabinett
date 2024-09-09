//
//  CustomStrokePathView.swift
//  Kabinett
//
//  Created by uunwon on 9/9/24.
//

import SwiftUI

struct CustomStrokePathView: View {
    var body: some View {
        ZStack {
            Color.primary100.opacity(0.1)
                .background(TransparentBlurView(removeAllFilters: true))
            
            Path { path in
                let rect = CGRect(
                    x: 0,
                    y: 0,
                    width: LayoutHelper.shared.getWidth(forSE: 0.34, forOthers: 0.37),
                    height: LayoutHelper.shared.getSize(forSE: 0.27, forOthers: 0.252)
                )
                
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            }
            .stroke(Color.primary600.opacity(0.3), lineWidth: 0.2)
        }
        .shadow(color:.contentSecondary.opacity(0.3), radius: 2, y: CGFloat(3))
        .frame(width: LayoutHelper.shared.getWidth(forSE: 0.34, forOthers: 0.37),
               height: LayoutHelper.shared.getSize(forSE: 0.27, forOthers: 0.252))
        .padding(.top, LayoutHelper.shared.getSize(forSE: 0.042, forOthers: 0.042))
    }
}
