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
        ZStack {
            Color.background
            
            LazyVGrid(columns: columns, spacing: 40) {
                ForEach(LetterBoxType.allCases) { type in
                    LetterBoxCell(type: "\(type)", typeName: type.rawValue)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct LetterBoxCell: View {
    var type: String = "All"
    var typeName: String = "전체 편지"
    
    var body: some View {
        VStack {
            ZStack {
                LetterBoxEnvelopeCell()
                
                Rectangle()
                    .fill(.clear)
                    .background(.ultraThinMaterial)
                    .frame(width: 125, height: 180)
                    .opacity(0.8)
                    .padding(.top, 31)
                    .shadow(radius: 1, y: CGFloat(3))
                    .blendMode(.luminosity)
                
                Text(type)
                    .font(.system(size: 12, design: .serif))
                    .offset(y: 90)
            }
            .padding(.bottom, 12)
            
            HStack {
                Text(typeName)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
                
//                새로 도착한 편지에 대한 알림
//                ZStack {
//                    Circle()
//                        .fill(.red)
//                        .frame(width: 17)
//                    Text("1")
//                        .font(.system(size: 9))
//                        .foregroundStyle(.alert)
//                }
//                .padding(.leading, -2)
            }
            
        }
        
        
    }
}


#Preview {
    LetterBoxView()
}
