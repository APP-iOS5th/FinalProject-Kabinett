//
//  LetterWriteLoadStuffUseCaseWrapper.swift
//  Kabinett
//
//  Created by 김정우 on 9/1/24.
//

import Foundation

class LetterWriteLoadStuffUseCaseWrapper: LetterWriteLoadStuffUseCase {
    private let componentsLoadStuffUseCase: ComponentsLoadStuffUseCase
    
    init(_ componentsLoadStuffUseCase: ComponentsLoadStuffUseCase) {
        self.componentsLoadStuffUseCase = componentsLoadStuffUseCase
    }
    
    func loadEnvelopes() async -> Result<[String], any Error> {
        return await componentsLoadStuffUseCase.loadEnvelopes()
    }
    
    func loadStamps() async -> Result<[String], any Error> {
        return await componentsLoadStuffUseCase.loadStamps()
    }
    
    func loadStationeries() async -> Result<[String], any Error> {
        return .success([])
    }
}
