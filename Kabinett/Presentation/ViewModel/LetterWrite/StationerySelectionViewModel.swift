//
//  StationerySelectionViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/19/24.
//

import Foundation
import SwiftUI
import Combine

class StationerySelectionViewModel: ObservableObject {
    
    @Published var showModal = true
    @Published var selectedIndex: (Int, Int) = (0, 0)
    
    @Published var dummyStationerys: [String] = [
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_122/imyubin__1474262528136yOuds_PNG/image_6979828871474262466901.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800"
    ]
    
    var numberOfRows: Int {
        (dummyStationerys.count + 1) / 2
    }
    
    func index(row: Int, column: Int) -> Int {
        return row * 2 + column
    }
    
    func selectStationery(coordinates: (Int, Int)) {
        selectedIndex = coordinates
    }
    
    func isSelected(coordinates: (Int, Int)) -> Bool {
        return selectedIndex == coordinates
    }
}
