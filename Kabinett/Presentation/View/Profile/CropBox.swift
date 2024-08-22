//
//  CropBox.swift
//  Kabinett
//
//  Created by Yule on 8/21/24.
//

import Foundation
import SwiftUI

public struct CropBox: View {
    @Binding public var rect: CGRect // 크롭박스 현재 위치와 크기
    public let minSize: CGSize
    
    @State private var initialRect: CGRect? = nil
    @State private var frameSize: CGSize = .zero // 현재 화면 크기
    @State private var draggedCorner: UIRectCorner? = nil // 드래그 중인 크롭 박스 모서리 추적
    
    public init(
        rect: Binding<CGRect>,
        minSize: CGSize = .init(width: 100, height: 100)
    ) {
        self._rect = rect
        self.minSize = minSize
    }
    
    private var rectDrag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if initialRect == nil {
                    initialRect = rect
                    draggedCorner = closestCorner(point: gesture.startLocation, rect: rect)
                }
                
                if let draggedCorner {
                    self.rect = dragResize(
                        initialRect: initialRect!,
                        draggedCorner: draggedCorner,
                        frameSize: frameSize,
                        translation: gesture.translation
                    )
                } else {
                    self.rect = drag(
                        initialRect: initialRect!,
                        frameSize: frameSize,
                        translation: gesture.translation
                    )
                }
            }
            .onEnded { _ in
                initialRect = nil
                draggedCorner = nil
            }
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            blur
            box
        }
        .background {
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        self.frameSize = geometry.size
                        self.centerCropBox()
                    }
                    .onChange(of: geometry.size) { newSize in
                        self.frameSize = newSize
                        self.centerCropBox()
                    }
            }
        }
    }
    
    private func centerCropBox() {
        rect.origin.x = (frameSize.width - rect.width) / 2
        rect.origin.y = (frameSize.height - rect.height) / 2
    }
    
    private var blur: some View {
        Color.black.opacity(0.5)
            .overlay(alignment: .topLeading) {
                Color.white
                    .frame(width: rect.width - 1, height: rect.height - 1)
                    .offset(x: rect.origin.x, y: rect.origin.y)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .drawingGroup()
            .blendMode(.multiply)
    }
    
    private var box: some View {
        ZStack {
            grid
            pins
        }
        .border(.white, width: 1.5)
        .background(Color.white.opacity(0.001))
        .frame(width: rect.width, height: rect.height)
        .offset(x: rect.origin.x, y: rect.origin.y)
        .gesture(rectDrag)
    }
    
    private var pins: some View {
        VStack {
            HStack {
                pin(corner: .topLeft)
                Spacer()
                pin(corner: .topRight)
            }
            Spacer()
            HStack {
                pin(corner: .bottomLeft)
                Spacer()
                pin(corner: .bottomRight)
            }
        }
    }
    
    private func pin(corner: UIRectCorner) -> some View {
        var offX = 1.0
        var offY = 1.0
        
        switch corner {
        case .topLeft:      offX = -1;  offY = -1
        case .topRight:                 offY = -1
        case .bottomLeft:   offX = -1
        case .bottomRight: break
        default: break
        }
        
        return Circle()
            .fill(.white)
            .frame(width: 16, height: 16)
            .offset(x: offX * 8, y: offY * 8)
    }
    
    private var grid: some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 1.5)
                .frame(maxHeight: .infinity)
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                Spacer()
                Rectangle()
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                Spacer()
            }
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
        }
        .foregroundColor(.gray)
    }
    
    private func closestCorner(point: CGPoint, rect: CGRect, distance: CGFloat = 16) -> UIRectCorner? {
        let ldX = abs(rect.minX.distance(to: point.x)) < distance
        let rdX = abs(rect.maxX.distance(to: point.x)) < distance
        let tdY = abs(rect.minY.distance(to: point.y)) < distance
        let bdY = abs(rect.maxY.distance(to: point.y)) < distance
        
        guard (ldX || rdX) && (tdY || bdY) else { return nil }
        
        if ldX && tdY { return .topLeft }
        if rdX && tdY { return .topRight }
        if ldX && bdY { return .bottomLeft }
        if rdX && bdY { return .bottomRight }
        
        return nil
    }
    
    private func dragResize(initialRect: CGRect, draggedCorner: UIRectCorner, frameSize: CGSize, translation: CGSize) -> CGRect {
        var offX = 1.0
        var offY = 1.0
        
        switch draggedCorner {
        case .topLeft: offX = -1;  offY = -1
        case .topRight: offY = -1
        case .bottomLeft: offX = -1
        case .bottomRight: break
        default: break
        }
        
        let idealWidth = initialRect.size.width + offX * translation.width
        let idealHeight = initialRect.size.height + offY * translation.height // 드래그한 거리에 따라 크롭박스 크기 계산
        
        var newWidth = max(idealWidth, minSize.width)
        var newHeight = max(idealHeight, minSize.height)
        
        let centerX = initialRect.midX
        let centerY = initialRect.midY
        
        newWidth = min(newWidth, frameSize.width)
        newHeight = min(newHeight, frameSize.height)
        
        let newX = centerX - newWidth / 2
        let newY = centerY - newHeight / 2
        
        return CGRect(origin: CGPoint(x: newX, y: newY), size: CGSize(width: newWidth, height: newHeight))
    } // 크롭 박스를 중앙 점을 기준으로 확대, 축소
    
    private func drag(initialRect: CGRect, frameSize: CGSize, translation: CGSize) -> CGRect {
        let maxX = frameSize.width - initialRect.width
        let newX = min(max(initialRect.origin.x + translation.width, 0), maxX)
        let maxY = frameSize.height - initialRect.height
        let newY = min(max(initialRect.origin.y + translation.height, 0), maxY)
        
        return CGRect(origin: CGPoint(x: newX, y: newY), size: initialRect.size)
    }
}
