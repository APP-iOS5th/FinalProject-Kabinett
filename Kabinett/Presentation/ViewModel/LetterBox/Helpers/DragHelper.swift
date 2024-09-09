//
//  DragHelper.swift
//  Kabinett
//
//  Created by uunwon on 9/7/24.
//

import SwiftUI

struct DragHelper {
    static func handleDragGesture(value: DragGesture.Value, offset: inout CGFloat, showDeleteButton: inout Bool) {
        if value.translation.width < 0 {
            offset = value.translation.width
            if offset < -60 {
                showDeleteButton = true
            }
        }
    }
    
    static func handleDragEnd(offset: inout CGFloat, showDeleteButton: inout Bool) {
        if offset < -60 {
            offset = -60
        } else {
            offset = 0
            showDeleteButton = false
        }
    }
}
