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
    
    @State private var currentLetterType: LetterType = .all
    @State private var showToast: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color.background
                        .ignoresSafeArea()
                    
                    LazyVGrid(columns: gridItems(), spacing: LayoutHelper.shared.getSize(forSE: 0.039, forOthers: 0.039)) {
                        ForEach(LetterType.allCases, id: \.self) { type in
                            let unreadCount = letterBoxViewModel.getIsReadLetters(for: type)
                            
                            NavigationLink(destination: LetterBoxDetailView(letterType: type)) {
                                LetterBoxCell(type: type, unreadCount: unreadCount)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                currentLetterType = type
                            })
                        }
                    }
                    .padding(.top, LayoutHelper.shared.getSize(forSE: 0.035, forOthers: 0.035))
                    
                    VStack {
                        if showToast {
                            Spacer()
                            ToastView(message: "카비넷 팀이 보낸 편지가 도착했습니다.", horizontalPadding: 50)
                                .transition(.move(edge: .bottom))
                                .zIndex(1)
                                .onAppear {
                                    letterBoxViewModel.fetchWelcomeLetter()
                                    
                                    Timer.scheduledTimer(withTimeInterval: 3.3, repeats: false) { _ in
                                        withAnimation {
                                            showToast = false
                                        }
                                    }
                                }
                                .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.0004, forOthers: 0.001))
                        }
                    }
                }
                .onAppear() {
                    withAnimation {
                        if isFirstLaunch {
                            showToast = true
                            isFirstLaunch = false
                        }
                    }
                    
                    if calendarViewModel.startDateFiltering {
                        calendarViewModel.startDateFiltering.toggle()
                    }
                    
                    letterBoxViewModel.fetchLetterBoxLetters()
                    letterBoxViewModel.fetchIsRead()
                }
            }
            .tint(.black)
        }
    }
    
    func gridItems() -> [GridItem] {
        [
            GridItem(.flexible(minimum: 220), spacing: LayoutHelper.shared.getSize(forSE: -0.1, forOthers: -0.063)),
            GridItem(.flexible(minimum: 220))
        ]
    }
}

//#Preview {
//    LetterBoxView()
//        .environmentObject(LetterBoxViewModel())
//        .environmentObject(CalendarViewModel())
//}
