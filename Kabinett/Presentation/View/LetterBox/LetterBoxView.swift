//
//  LetterBoxView.swift
//  Kabinett
//
//  Created by uunwon on 8/13/24.
//

import SwiftUI

struct LetterBoxView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    @EnvironmentObject var letterBoxViewModel: LetterBoxViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                LazyVGrid(columns: gridItems(), spacing: LayoutHelper.shared.getSize(forSE: 0.039, forOthers: 0.039)) {
                    ForEach(LetterType.allCases, id: \.self) { type in
                        let unreadCount = letterBoxViewModel.getIsReadLetters(for: type)
                        
                        NavigationLink(destination: LetterBoxDetailView()) {
                            LetterBoxCell(type: type, unreadCount: unreadCount)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            calendarViewModel.currentLetterType = type
                        })
                    }
                }
                .padding(.top, LayoutHelper.shared.getSize(forSE: 0.035, forOthers: 0.035))
                
                VStack {
                    Spacer()
                    ToastView(message: "카비넷 팀의 편지가 도착했어요.", showToast: $letterBoxViewModel.showToast)
                }
            }
            .onAppear() {
                withAnimation {
                    if isFirstLaunch {
                        letterBoxViewModel.fetchWelcomeLetter()
                        isFirstLaunch = false
                    }
                }
            }
        }
        .tint(.black)
    }
    
    func gridItems() -> [GridItem] {
        [
            GridItem(.flexible(minimum: 220), spacing: LayoutHelper.shared.getSize(forSE: -0.1, forOthers: -0.063)),
            GridItem(.flexible(minimum: 220))
        ]
    }
}
