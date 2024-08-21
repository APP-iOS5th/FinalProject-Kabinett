//
//  LoadLetterStuffUseCase.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/20/24.
//

import Foundation

protocol LetterWriteLoadStuffUseCase {
    func loadEnvelopes() async -> Result<[String], any Error>
    func loadStamps() async -> Result<[String], any Error>
    func loadStationeries() async -> Result<[String], any Error>
}
