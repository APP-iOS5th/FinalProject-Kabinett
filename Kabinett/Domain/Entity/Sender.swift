//
//  Sender.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/12/24.
//

import Foundation
import FirebaseFirestore

struct Sender: Codable, Identifiable {
    @DocumentID var id: String?
    
    let name: String
    let kabinettNumber: Int
    let profileImage: String?
}
