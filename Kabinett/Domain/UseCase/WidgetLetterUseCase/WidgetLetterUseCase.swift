//
//  WidgetLetterUseCase.swift
//  Kabinett
//
//  Created by Jihye Seok on 4/18/25.
//

import Foundation
import Combine

protocol WidgetLetterUseCase {
    func fetchWidgetLetters(
        userId: String,
        letterType: WidgetLetterType
    ) -> AnyPublisher<[WidgetLetter], Never>
}
