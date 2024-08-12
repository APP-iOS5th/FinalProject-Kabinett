//
//  Writer.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/12/24.
//

import Foundation
import FirebaseFirestore

struct Writer: Codable, Identifiable {
    @DocumentID var id: String?
    
    let name: String
    let kabinettNumber: Int
    let profileImage: String?
}
