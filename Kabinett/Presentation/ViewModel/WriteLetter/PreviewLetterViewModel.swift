//
//  LetterWritePreviewViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/30/24.
//

import Foundation
import SwiftUI

class PreviewLetterViewModel: ObservableObject {
    private let useCase: WriteLetterUseCase
    
    @Published var isSaveSuccessful: Bool = false
    @Published var errorMessage: String? = nil
    
    init(useCase: WriteLetterUseCase) {
        self.useCase = useCase
    }
    
    func saveLetter(font: String,
                    postScript: String?,
                    envelope: String,
                    stamp: String,
                    fromUserId: String?,
                    fromUserName: String,
                    fromUserKabinettNumber: Int?,
                    toUserId: String?,
                    toUserName: String,
                    toUserKabinettNumber: Int?,
                    content: [String],
                    photoContents: [Data],
                    date: Date,
                    stationery: String,
                    isRead: Bool) {
        
        Task {
            let result = await useCase.saveLetter(font: font,
                                                  postScript: postScript,
                                                  envelope: envelope,
                                                  stamp: stamp,
                                                  fromUserId: fromUserId,
                                                  fromUserName: fromUserName,
                                                  fromUserKabinettNumber: fromUserKabinettNumber,
                                                  toUserId: toUserId,
                                                  toUserName: toUserName,
                                                  toUserKabinettNumber: toUserKabinettNumber,
                                                  content: content,
                                                  photoContents: photoContents,
                                                  date: date,
                                                  stationery: stationery,
                                                  isRead: isRead)
            await MainActor.run {
                switch result {
                case .success(let success):
                    self.isSaveSuccessful = success
                    if !success {
                        self.errorMessage = "편지 저장 실패."
                    }
                case .failure(let error):
                    self.isSaveSuccessful = false
                    self.errorMessage = "오류 발생: \(error.localizedDescription)"
                    print("Save Letter Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
