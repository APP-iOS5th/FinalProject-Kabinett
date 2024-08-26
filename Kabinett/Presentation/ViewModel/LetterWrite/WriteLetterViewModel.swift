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
        let totalLines = text.components(separatedBy: "\n").count
        pageCnt = max(1, (totalLines + maxLinesPerPage - 1) / maxLinesPerPage)
    }
    
    /*
     func adjustPageCount() {
         var counter: Int = 0
         text.components(separatedBy: "\n").forEach { line in
             let label = UILabel()
             label.font = .systemFont(ofSize: 13)
             label.text = line
             label.sizeToFit()
             let currentTextWidth = label.frame.width
             counter += Int(ceil(currentTextWidth / maxTextWidth))
         }
         pageCnt = max(1, (counter + maxLinesPerPage - 1) / maxLinesPerPage)
     }
     */
}
