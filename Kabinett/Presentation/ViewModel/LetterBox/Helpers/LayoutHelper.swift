//
//  LayoutHelper.swift
//  Kabinett
//
//  Created by uunwon on 9/6/24.
//

import SwiftUI

struct LayoutHelper {
    static let shared = LayoutHelper()
    
    private var isSEDevice: Bool = false
    
    private init() {
        self.isSEDevice = checkDevice()
    }
    
    private func checkDevice() -> Bool {
        let deviceName = UIDevice.current.name
        return deviceName.contains("SE")
    }
    
    func getWidth(forSE: CGFloat, forOthers: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width * (isSEDevice ? forSE : forOthers)
    }
    
    func getSize(forSE: CGFloat, forOthers: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.height * (isSEDevice ? forSE : forOthers)
    }
    
    static func calculateOffsetAndRotation(for index: Int, totalCount: Int) -> (xOffset: CGFloat, yOffset: CGFloat, rotation: Double) {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            switch totalCount {
            case 1:
                return (xOffset: screenWidth * -0.027, yOffset: screenHeight * -0.002, rotation: Double(-1.5))
            case 2:
                let xOffset = index == 0 ? screenWidth * -0.018 : screenWidth * 0.015
                let yOffset = index == 0 ? screenHeight * -0.01 : screenHeight * -0.001
                let rotation = index == 0 ? -1 : 0
                return (xOffset: xOffset, yOffset: yOffset, rotation: Double(rotation))
            case 3:
                let xOffsets = [screenWidth * -0.029, screenWidth * -0.02, screenWidth * 0.029]
                let yOffsets = [screenHeight * -0.002, screenHeight * -0.01, screenHeight * -0.002]
                return (xOffset: xOffsets[index], yOffset: yOffsets[index], rotation: 0)
            default:
                return (xOffset: 0, yOffset: 0, rotation: 0)
            }
    }
}
