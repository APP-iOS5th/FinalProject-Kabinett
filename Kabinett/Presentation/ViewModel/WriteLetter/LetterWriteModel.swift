//
//  LetterViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/14/24.
//

import Foundation
import SwiftUI

class LetterWriteModel: ObservableObject {
    @Published var writeLetter: WriteLetter = WriteLetter(envelopeImageUrlString: "", stampImageUrlString: "", fromUserName: "", toUserName: "", content: [], date: Date(), stationeryImageUrlString: "", isRead: false)
}

struct WriteLetter {
    var fontString: String?
    var postScript: String?
    var envelopeImageUrlString: String
    var stampImageUrlString: String
    var fromUserId: String?
    var fromUserName: String
    var fromUserKabinettNumber: Int?
    var toUserId: String?
    var toUserName: String
    var toUserKabinettNumber: Int?
    var content: [String]
    var photoContents: [Data]?
    var date: Date
    var stationeryImageUrlString: String
    var isRead: Bool
}
