//
//  ComponentsUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/12/24.
//

import Foundation

protocol ComponentsUseCase {
    func saveLetter(postScript: String?, envelope: String, stamp: String, fromUserId: String, toUserId: String, photoContents: [String], date: Date, isRead: Bool) async -> Result<Void, any Error>
}