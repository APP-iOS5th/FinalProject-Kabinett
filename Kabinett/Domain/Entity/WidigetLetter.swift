//
//  WidigetLetter.swift
//  Kabinett
//
//  Created by Jihye Seok on 4/15/25.
//

import Foundation
import FirebaseFirestore

struct WidgetLetter: Codable, Identifiable {
    @DocumentID var id: String?
    
    let fontString: String
    let postScript: String
    let envelopeImageUrlString: String
    let stampImageUrlString: String
    let fromUserId: String?
    let fromUserName: String
    let toUserId: String?
    let toUserName: String
    let date: Date
    var isRead: Bool
}
