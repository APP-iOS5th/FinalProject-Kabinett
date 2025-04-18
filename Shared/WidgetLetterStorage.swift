//
//  WidgetLetterStorage.swift
//  Kabinett
//
//  Created by Jihye Seok on 4/18/25.
//

import Foundation
import os

final class WidgetLetterStorage {
    private let logger: Logger
    
    init() {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "WidgetLetterStorage"
        )
    }
    private let appGroupID = Bundle.main.object(forInfoDictionaryKey: "APP_GROUP_ID") as? String ?? ""
    
    func save(_ letters: [WidgetLetter]) {
        guard let defaults = UserDefaults(suiteName: appGroupID) else { return }
        
        do {
            let data = try JSONEncoder().encode(letters)
            defaults.set(data, forKey: appGroupID)
        } catch {
            logger.error("위젯 데이터 저장 실패: \(error.localizedDescription)")
        }
    }
}
