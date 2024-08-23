//
//  WriteLetterViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import Foundation
import SwiftUI

//class SizeSetting: ObservableObject {
//    @Published var horizontal: CGFloat = .zero
//    @Published var height: CGFloat = .zero
//
//    func updateSize(from geometry: GeometryProxy) {
//        self.horizontal = geometry.size.width * 0.06
//        self.height = geometry.size.height * 0.44
//    }
//}

class WriteLetterViewModel: ObservableObject {
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}
