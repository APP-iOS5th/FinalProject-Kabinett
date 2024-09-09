//
//  Extension+LetterType.swift
//  Kabinett
//
//  Created by uunwon on 9/6/24.
//

import Foundation

extension LetterType {
    var description: String {
            switch self {
            case .all:
                return "All"
            case .toMe:
                return "To me"
            case .sent:
                return "Sent"
            case .received:
                return "Recieved"
            }
        }
    
    func koName() -> String {
        switch self {
        case .all:
            return "전체 편지"
        case .toMe:
            return "나에게 보낸 편지"
        case .sent:
            return "보낸 편지"
        case .received:
            return "받은 편지"
        }
    }
    
    func setEmptyMessage() -> String {
        switch self {
        case .all:
            return "아직 편지가 없어요."
        case .toMe:
            return "아직 나에게 보낸 편지가 없어요."
        case .sent:
            return "아직 보낸 편지가 없어요."
        case .received:
            return "아직 받은 편지가 없어요."
        }
    }
}
