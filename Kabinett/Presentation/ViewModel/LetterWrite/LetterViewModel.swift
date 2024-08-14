//
//  LetterViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/14/24.
//

import Foundation

class LetterViewModel: ObservableObject {
    @Published var fontString: String = ""
    @Published var postScript: String = ""
    @Published var envelopeImageUrlString: String = ""
    @Published var stampImageUrlString: String = ""
    @Published var fromUserId: String = ""
    @Published var toUserId: String = ""
    @Published var content: String = ""
    @Published var photoContents: [String] = []
    @Published var date: Date = Date()
    @Published var stationeryImageUrlString: String = ""
    @Published var isRead: Bool = false
}
