//
//  DefaultWidgetUseCase.swift
//  Kabinett
//
//  Created by Jihye Seok on 4/18/25.
//

import Foundation
import os
import Combine

final class DefaultWidgetUseCase {
    private let logger: Logger
//    private let storage: WidgetUserDefaults
    private let widgetManager: FirestoreWidgetManager
    private let authManager: AuthManager
    
    init(
//        storage: WidgetUserDefaults,
        widgetManager: FirestoreWidgetManager,
        authManager: AuthManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultWidgetUseCase"
        )
//        self.storage = storage
        self.widgetManager = widgetManager
        self.authManager = authManager
    }
}

extension DefaultWidgetUseCase: WidgetUseCase {
    func fetchWidgetLetters(letterType: WidgetLetterType) -> AnyPublisher<[WidgetLetter], Never> {
        authManager.getCurrentUser()
            .compactMap { $0?.uid }
            .flatMap { userId in
                self.widgetManager.getWidgetLetter(userId: userId, letterType: letterType)
            }
//            .handleEvents(receiveOutput: { [weak self] letters in
//                self?.storage.save(letters)
//            })
            .eraseToAnyPublisher()
    }
}
