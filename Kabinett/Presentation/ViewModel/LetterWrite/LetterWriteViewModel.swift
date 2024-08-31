//
//  LetterViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/14/24.
//

import Foundation
import SwiftUI

class LetterWriteViewModel: ObservableObject {
    @Published var fontString: String? = nil
    @Published var postScript: String? = nil
    @Published var envelopeImageUrlString: String = ""
    @Published var stampImageUrlString: String = ""

    @Published var fromUserId: String? = nil
    @Published var fromUserName: String = ""
    @Published var fromUserKabinettNumber: Int? = nil
    
    @Published var toUserId: String? = nil
    @Published var toUserName: String = ""
    @Published var toUserKabinettNumber: Int? = nil
    
    @Published var content: String? = nil
    @Published var photoContents: [String] = []
    @Published var date: Date = Date()
    @Published var stationeryImageUrlString: String? = nil
    @Published var isRead: Bool = false
    @Published var dataSource: DataSource = .fromImagePicker
    
    enum DataSource {
        case fromLetterWriting
        case fromImagePicker
    }
}
