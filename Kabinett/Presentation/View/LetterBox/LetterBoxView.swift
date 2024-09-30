//
//  LetterBoxView.swift
//  Kabinett
//
//  Created by uunwon on 8/13/24.
//

import SwiftUI

struct LetterBoxView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @EnvironmentObject var customTabViewModel: CustomTabViewModel
    @EnvironmentObject var letterBoxViewModel: LetterBoxViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    @State private var showToast: Bool = false
    
    var body: some View {
        NavigationStack(path: $customTabViewModel.letterBoxNavigationPath) {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                LazyVGrid(columns: gridItems(), spacing: LayoutHelper.shared.getSize(forSE: 0.039, forOthers: 0.039)) {
                    ForEach(LetterType.allCases, id: \.self) { type in
                        let unreadCount = letterBoxViewModel.getIsReadLetters(for: type)
                        
                        NavigationLink(value: type) {
                            LetterBoxCell(type: type, unreadCount: unreadCount)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            calendarViewModel.currentLetterType = type
                        })
                    }
                }
                .padding(.top, LayoutHelper.shared.getSize(forSE: 0.035, forOthers: 0.035))
                
                VStack {
                    if showToast {
                        Spacer()
                        ToastView(message: "카비넷 팀의 편지가 도착했어요.", horizontalPadding: 50)
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
                            .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.01, forOthers: 0.01))
                    }
                }
            }
            .navigationDestination(for: LetterType.self) { type in
                LetterBoxDetailView()
            }
            .onAppear() {
                withAnimation {
                    if isFirstLaunch {
                        showToast = true
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

//#Preview {
//    LetterBoxView()
//        .environmentObject(LetterBoxViewModel())
//        .environmentObject(CalendarViewModel())
//}
