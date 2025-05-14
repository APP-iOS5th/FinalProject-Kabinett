//
//  WidgetViewModel.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 5/8/25.
//

import Foundation
import Combine
import os

final class WidgetViewModel: ObservableObject {
    private let logger: Logger
    private let widgetUseCase: WidgetUseCase
    private let userDefaults: WidgetUserDefaults
    private var cancellables: Set<AnyCancellable> = []
    
    init(widgetUseCase: WidgetUseCase, userDefaults: WidgetUserDefaults) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "WidgetViewModel"
        )
        self.widgetUseCase = widgetUseCase
        self.userDefaults = userDefaults
    }
    
    func syncWidgetLetters() {
        widgetUseCase.fetchWidgetLetters(letterType: .received)
            .sink { [weak self] letters in
                self?.userDefaults.save(letters)
                self?.logger.info("위젯 데이터 fetch 및 저장 완료: \(letters)")
            }
            .store(in: &cancellables)
    }
}
