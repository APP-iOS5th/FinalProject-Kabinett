//
//  LetterWritePreviewViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/30/24.
//

import Foundation
import SwiftUI

class PreviewLetterViewModel: ObservableObject {
    @Published var isSaveSuccessful: Bool = false
    @Published var errorMessage: String? = nil
    
    private let useCase: WriteLetterUseCase
    
    init(useCase: WriteLetterUseCase) {
        self.useCase = useCase
    }
    
    func saveLetter(letter: WriteLetter) {
        
        Task {
            let result = await useCase.saveLetter(font: letter.fontString ?? "",
                                                  postScript: letter.postScript,
                                                  envelope: letter.envelopeImageUrlString,
                                                  stamp: letter.stampImageUrlString,
                                                  fromUserId: letter.fromUserId,
                                                  fromUserName: letter.fromUserName,
                                                  fromUserKabinettNumber: letter.fromUserKabinettNumber,
                                                  toUserId: letter.toUserId,
                                                  toUserName: letter.toUserName,
                                                  toUserKabinettNumber: letter.toUserKabinettNumber,
                                                  content: letter.content,
                                                  photoContents: letter.photoContents ?? [],
                                                  date: letter.date,
                                                  stationery: letter.stationeryImageUrlString,
                                                  isRead: letter.isRead)
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
                
                NotificationCenter.default.post(
                    name: .showToast,
                    object: nil,
                    userInfo: isSaveSuccessful ? ["message": "편지가 성공적으로 전송되었어요.", "color": Color.primary900] : ["message": "앗..!! 편지 전송을 실패했어요..", "color": Color.alert])
            }
        }
    }
}
