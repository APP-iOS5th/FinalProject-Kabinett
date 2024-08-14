//
//  LetterBoxView.swift
//  Kabinett
//
//  Created by uunwon on 8/13/24.
//

import SwiftUI

enum LetterBoxType: String, CaseIterable, Identifiable {
    case All = "전체 편지"
    case Tome = "나에게 보낸 편지"
    case Sent = "보낸 편지"
    case Recieved = "받은 편지"
    
    var id: String { self.rawValue }
}

struct LetterBoxView: View {
    let columns = [
        GridItem(.flexible(minimum: 220), spacing: -70),
        GridItem(.flexible(minimum: 220))
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(LetterBoxType.allCases) { type in
                        NavigationLink(destination: LetterBoxDetailView(letterBoxType: "\(type)")) {
                            LetterBoxCell(type: "\(type)", typeName: type.rawValue)
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
        .tint(.black)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LetterBoxView()
}
