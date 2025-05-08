//
//  WidgetUserDefaults.swift
//  Kabinett
//
//  Created by Jihye Seok on 4/18/25.
//

import Foundation
import os

final class WidgetUserDefaults {
    private let logger: Logger
    private let appGroupID = Bundle.main.object(forInfoDictionaryKey: "APP_GROUP_ID") as? String ?? ""
    
    init() {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "WidgetUserDefaults"
        )
    }
    
    func save(_ letters: [WidgetLetter]) {
        guard let defaults = UserDefaults(suiteName: appGroupID) else { return }
        do {
            let data = try JSONEncoder().encode(letters)
            print("userdefaults 저장되는 data : \(data)")
            defaults.set(data, forKey: appGroupID)
        } catch {
            logger.error("위젯 데이터 저장 실패: \(error.localizedDescription)")
        }
    }
    
    func load() -> [WidgetLetter] {
        guard
            let defaults = UserDefaults(suiteName: appGroupID),
            let data = defaults.data(forKey: appGroupID),
            let letters = try? JSONDecoder().decode([WidgetLetter].self, from: data)
        else {
            return []
        }
        return letters
    }
}
