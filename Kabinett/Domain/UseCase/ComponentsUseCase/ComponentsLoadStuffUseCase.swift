//
//  ComponentsLoadStuffUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/21/24.
//

import Foundation

protocol ComponentsLoadStuffUseCase {
    func loadEnvelopes() async -> Result<[String], any Error>
    func loadStamps() async -> Result<[String], any Error>
}
