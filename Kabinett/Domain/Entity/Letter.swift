//
//  Letter.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/12/24.
//

import Foundation
import FirebaseFirestore

struct Letter: Codable, Identifiable {
    @DocumentID var id: String?
    
    let fontString: String
    let postScript: String
    let envelopeImageUrlString: String
    let stampImageUrlString: String
    let fromUserId: String
    let toUserId: String
    let content: String?
    let photoContents: [String]
    let date: Date
    let staioneryImageUrlString: String
    let isRead: Bool
}
