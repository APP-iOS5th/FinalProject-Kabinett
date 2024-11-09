//
//  UseCaseKeys.swift
//  Kabinett
//
//  Created by jinwoong Kim on 10/6/24.
//

import Foundation

// MARK: - The Keys of UseCases
/// Same as `ServiceKey`
struct SignUpUseCaseKey: InjectionKey {
    typealias Value = SignUpUseCase
}

struct ProfileUseCaseKey: InjectionKey {
    typealias Value = ProfileUseCase
}

struct WriteLetterUseCaseKey: InjectionKey {
    typealias Value = WriteLetterUseCase
}

struct LetterBoxUseCaseKey: InjectionKey {
    typealias Value = LetterBoxUseCase
}

struct ImportLetterUseCaseKey: InjectionKey {
    typealias Value = ImportLetterUseCase
}
