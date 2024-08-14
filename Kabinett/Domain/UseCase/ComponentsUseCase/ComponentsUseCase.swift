//
//  ComponentsUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/12/24.
//

import Foundation

protocol ComponentsUseCase {
<<<<<<< HEAD
    func saveLetter(postScript: String?, envelope: String, stamp: String, fromUserId: String, toUserId: String, photoContents: [String], date: Date, isRead: Bool) async -> Result<Void, Error>
=======
    func saveLetter(postScript: String?, envelope: String, stamp: String, fromUserId: String, toUserId: String, photoContents: [String], date: Date, isRead: Bool) async -> Result<Void, any Error>
>>>>>>> 348edc19f520cca460d1ff70b93953656e618c98
}
