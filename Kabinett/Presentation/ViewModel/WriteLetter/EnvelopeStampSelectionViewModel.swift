//
//  EnvelopeStampSelectionViewModal.swift
//  Kabinett
//
//  Created by Song Kim on 8/27/24.
//

import Foundation
import SwiftUI

class EnvelopeStampSelectionViewModel: ObservableObject {
    @Published var envelopeSelectedIndex: (Int, Int) = (0, 0)
    @Published var stampSelectedIndex: (Int, Int) = (0, 0)
    
    @Published var envelopes: [String] = []
    @Published var stamps: [String] = []
    
    private let useCase: WriteLetterUseCase
    
    init(useCase: WriteLetterUseCase) {
        self.useCase = useCase
        if envelopes.isEmpty {
            Task {
                await loadEnvelopes()
                await loadStamps()
            }
        }
    }
    
    var envelopeNumberOfRows: Int {
        (envelopes.count + 1) / 2
    }
    
    func envelopeIndex(row: Int, column: Int) -> Int {
        return row * 2 + column
    }
    
    func envelopeSelectStationery(coordinates: (Int, Int)) {
        envelopeSelectedIndex = coordinates
    }
    
    func isEnvelopeSelected(coordinates: (Int, Int)) -> Bool {
        return envelopeSelectedIndex == coordinates
    }
    
    var stampNumberOfRows: Int {
        (stamps.count + 1) / 3
    }
    
    func stampIndex(row: Int, column: Int) -> Int {
        return row * 3 + column
    }
    
    func stampSelectStationery(coordinates: (Int, Int)) {
        stampSelectedIndex = coordinates
    }
    
    func isStampSelected(coordinates: (Int, Int)) -> Bool {
        return stampSelectedIndex == coordinates
    }
    
    @MainActor
    func loadEnvelopes() async {
        let result = await useCase.loadEnvelopes()
        switch result {
        case .success(let urls):
            self.envelopes = urls
        case .failure(let error):
            print("Failed to load envelopes: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadStamps() async {
        let result = await useCase.loadStamps()
        switch result {
        case .success(let urls):
            self.stamps = urls
        case .failure(let error):
            print("Failed to load stamps: \(error.localizedDescription)")
        }
    }
}
