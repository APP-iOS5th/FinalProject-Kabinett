//
//  WidgetUseCase.swift
//  Kabinett
//
//  Created by Jihye Seok on 4/18/25.
//

import Foundation
import Combine

protocol WidgetUseCase {
    func fetchWidgetLetters(letterType: WidgetLetterType) -> AnyPublisher<[WidgetLetter], Never>
}
