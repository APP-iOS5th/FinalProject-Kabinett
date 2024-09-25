//
//  WriteLetterViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import SwiftUI

//class ContentWriteViewModel: ObservableObject {
//    @Published var text: String = ""
//    @Published var pageCnt: Int = 1
//
//    let maxCharactersPerPage = 340 // 한 페이지당 최대
//
//    // 페이지의 텍스트를 가져오는 메서드
//    func getPageText(for pageIndex: Int) -> String {
//        let startIndex = text.index(text.startIndex, offsetBy: pageIndex * maxCharactersPerPage, limitedBy: text.endIndex) ?? text.endIndex
//        let endIndex = text.index(startIndex, offsetBy: maxCharactersPerPage, limitedBy: text.endIndex) ?? text.endIndex
//        return String(text[startIndex..<endIndex])
//    }
//
//    // 특정 페이지의 텍스트를 업데이트하는 메서드
//    func updateText(for pageIndex: Int, with newValue: String) {
//        let startIndex = text.index(text.startIndex, offsetBy: pageIndex * maxCharactersPerPage, limitedBy: text.endIndex) ?? text.endIndex
//        let endIndex = text.index(startIndex, offsetBy: maxCharactersPerPage, limitedBy: text.endIndex) ?? text.endIndex
//        
//        text.replaceSubrange(startIndex..<endIndex, with: newValue)
//        adjustPageCount()
//    }
//
//    // 페이지 수 조정
//    func adjustPageCount() {
//        let totalCharacters = text.count
//        pageCnt = max(1, (totalCharacters + maxCharactersPerPage - 1) / maxCharactersPerPage)
//    }
//    
//    // 텍스트 초기화
//    func reset() {
//        text = ""
//        pageCnt = 1
//    }
//}

class ContentWriteViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var pageCnt: Int = 1
    
    let maxLinesPerPage = 15

    func getPageText(for pageIndex: Int) -> String {
        let lines = text.components(separatedBy: "\n")
        let startLine = pageIndex * maxLinesPerPage
        let endLine = min(startLine + maxLinesPerPage, lines.count)
        return lines[startLine..<endLine].joined(separator: "\n")
    }
    
    func updateText(for pageIndex: Int, with newValue: String) {
        var lines = text.components(separatedBy: "\n")
        let startLine = pageIndex * maxLinesPerPage
        let endLine = min(startLine + maxLinesPerPage, lines.count)
        lines.replaceSubrange(startLine..<endLine, with: newValue.components(separatedBy: "\n"))
        text = lines.joined(separator: "\n")
        adjustPageCount()
    }
    
    func adjustPageCount() {
        // 총 줄 수 계산 (줄 바꿈 문자를 기준으로)
        let totalLines = text.components(separatedBy: "\n").count
        pageCnt = max(1, (totalLines + maxLinesPerPage - 1) / maxLinesPerPage)
    }
    
    func reset() {
        text = ""
        pageCnt = 1
    }
}
