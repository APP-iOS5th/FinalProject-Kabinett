//
//  OptionOverlayGuide.swift
//  Kabinett
//
//  Created by 김정우 on 11/14/24.
//

import SwiftUI

struct OptionOverlayGuide: View {
    let text: String
    let boldText: String
    let position: GuidePosition
    let isVisible: Bool
    
    enum GuidePosition {
        case left
        case right
    }
    
    var attributedText: AttributedString {
        var text = AttributedString(text)
        if let range = text.range(of: boldText) {
            text[range].font = .system(size: 15, weight: .bold)
        }
        return text
    }
    
    var body: some View {
        VStack {
            if isVisible {
                HStack {
                    if position == .right {
                        Spacer()
                    }
                    
                    Text(attributedText)
                        .font(.system(size: 15))
                        .foregroundStyle(.primary100)
                        .lineLimit(3)
                        .multilineTextAlignment(position == .left ? .leading : .trailing)
                        .frame(width: 180)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            ZStack {
                                GuideShape(position: position)
                                    .fill(.primary600)
                                GuideTailShape(position: position)
                                    .fill(.primary600)
                            }
                                .frame(width: 180)
                                .frame(height: position == .right ? 85 : 85)
                        )
                        .offset(y: position == .right ? 0 : 0)
                        .shadow( color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
                    
                    if position == .left {
                        Spacer()
                    }
                    
                }
            }
        }
    }
}

struct GuideShape: Shape {
    let position: OptionOverlayGuide.GuidePosition
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bodyHeight: CGFloat = 85
        let cornerRadius: CGFloat = 25
        
        // top left corner
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: cornerRadius),
            control: CGPoint(x: rect.width, y: 0)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: bodyHeight - cornerRadius))
        
        // bottom right corner
        path.addQuadCurve(
            to: CGPoint(x: rect.width - cornerRadius, y: bodyHeight),
            control: CGPoint(x: rect.width, y: bodyHeight)
        )
        
        path.addLine(to: CGPoint(x: cornerRadius, y: bodyHeight))
        
        // bottom left corner
        path.addQuadCurve(
            to: CGPoint(x: 0, y: bodyHeight - cornerRadius),
            control: CGPoint(x: 0, y: bodyHeight)
        )
        
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        
        // top left corner
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        return path
    }
}

struct GuideTailShape: Shape {
    let position: OptionOverlayGuide.GuidePosition
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bodyHeight: CGFloat = 85
        let cornerRadius: CGFloat = 24
        
        if position == .left {
            path.move(to: CGPoint(x: cornerRadius, y: bodyHeight))
            path.addQuadCurve(
                to: CGPoint(x: 18, y: bodyHeight + 10),
                control: CGPoint(x: cornerRadius - 1, y: bodyHeight)
            )
            path.addQuadCurve(
                to: CGPoint(x: 0, y: bodyHeight - cornerRadius),
                control: CGPoint(x: 10, y: bodyHeight)
            )
        } else {
            path.move(to: CGPoint(x: rect.width - cornerRadius, y: bodyHeight))
            path.addQuadCurve(
                to: CGPoint(x: rect.width - 18, y: bodyHeight + 10),
                control: CGPoint(x: rect.width - (cornerRadius - 1), y: bodyHeight)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.width, y: bodyHeight - cornerRadius),
                control: CGPoint(x: rect.width - 10, y: bodyHeight)
            )
        }
        
        return path
    }
}

extension View {
    func optionOverlayGuide(text: String, boldText: String, position: OptionOverlayGuide.GuidePosition, isVisible: Bool = true) -> some View {
        self.overlay(
            OptionOverlayGuide(
                text: text,
                boldText: boldText,
                position: position,
                isVisible: isVisible
            )
            .offset(y: -100),
            alignment: .top
        )
    }
}

#Preview {
    HStack(spacing: 0) {
        OptionOverlayGuide(
            text: "간직하고 있던 편지를 촬영해 보관해요.",
            boldText: "촬영",
            position: .left,
            isVisible: true
        )
        
        OptionOverlayGuide(
            text: "카비넷 사용자라면 이름이나 번호를 검색해 편지를 보낼 수 있어요.",
            boldText: "이름이나 번호",
            position: .right,
            isVisible: true
        )
    }
    .padding(.leading, 50)
    
}
