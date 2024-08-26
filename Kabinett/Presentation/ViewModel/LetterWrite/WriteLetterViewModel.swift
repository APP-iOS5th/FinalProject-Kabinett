//
//  WriteLetterViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import Foundation
import SwiftUI

class WriteLetterViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var pageCnt: Int = 1

    let maxLinesPerPage = 16
    let lineHeight: CGFloat = 20 // 한 줄의 높이 (예: 20 포인트)

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }

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
}
