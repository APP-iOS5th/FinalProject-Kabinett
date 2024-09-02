//
//  LetterViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/28/24.
//

import Foundation
import SwiftUI

class LetterViewModel: ObservableObject {
    private let letterBoxUseCase: LetterBoxUseCase
    
    init(letterBoxUseCase: LetterBoxUseCase) {
        self.letterBoxUseCase = letterBoxUseCase
    }
    
    @Published var isRemove: Bool = false
    @Published var isRead: Bool = false
    
    @Published var offset: CGFloat = 0
    @Published var showDeleteButton = false
    
    @Published var errorMessage: String?
    
    func deleteLetter(letterId: String, letterType: LetterType) {
        Task { @MainActor in
            let result = await letterBoxUseCase.removeLetter(letterId: letterId, letterType: letterType)
            switch result {
            case .success(let isRemove):
                self.isRemove = isRemove
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func updateLetterReadStatus(letterId: String, letterType: LetterType) {
        Task { @MainActor in
            let result = await letterBoxUseCase.updateIsRead(letterId: letterId, letterType: letterType)
            switch result {
            case .success(let isRead):
                self.isRead = isRead
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func handleDragGesture(value: DragGesture.Value) {
        if value.translation.width < 0 {
            offset = value.translation.width
            if offset < -60 {
                showDeleteButton = true
            }
        }
    }
    
    func handleDragEnd() {
        if offset < -60 {
            offset = -60
        } else {
            offset = 0
            showDeleteButton = false
        }
    }
}
