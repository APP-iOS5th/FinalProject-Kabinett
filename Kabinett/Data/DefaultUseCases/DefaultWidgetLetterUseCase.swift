//
//  DefaultWidgetLetterUseCase.swift
//  Kabinett
//
//  Created by Jihye Seok on 4/18/25.
//

import Foundation
import os
import Combine

final class DefaultWidgetLetterUseCase {
    private let logger: Logger
    private let widgetManager: FirestoreWidgetManager
    private let authManager: AuthManager
    
    init(
        widgetManager: FirestoreWidgetManager,
        authManager: AuthManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultWidgetLetterUseCase"
        )
        self.widgetManager = widgetManager
        self.authManager = authManager
    }
}

extension DefaultWidgetLetterUseCase: WidgetLetterUseCase {
    func fetchWidgetLetters(userId: String, letterType: WidgetLetterType) -> AnyPublisher<[WidgetLetter], Never> {
        authManager.getCurrentUser()
            .compactMap { $0?.uid }
            .flatMap { userId in
                self.widgetManager.getWidgetLetter(userId: userId, letterType: letterType)
            }
            .eraseToAnyPublisher()
    }
}
