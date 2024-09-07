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
    
    @State private var searchText: String = ""
    @State private var showSearchBarView = false
    @State private var isTextFieldFocused = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color.background
                        .ignoresSafeArea()
                    
                    LazyVGrid(columns: gridItems(), spacing: LayoutHelper.shared.getSize(forSE: 0.039, forOthers: 0.039)) {
                        ForEach(LetterType.allCases, id: \.self) { type in
                            let unreadCount = letterBoxViewModel.getIsReadLetters(for: type)
                            
                            NavigationLink(destination: LetterBoxDetailView(letterType: type, showSearchBarView: $showSearchBarView, searchText: $searchText, isTextFieldFocused: $isTextFieldFocused)) {
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                        withAnimation {
                                            showToast = false
                                        }
                                    }
                                }
                                .padding(.bottom, LayoutHelper.shared.getSize(forSE: 0.0005, forOthers: 0.001))
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
                    showSearchBarView = false
                    searchText = ""
                    
                    if calendarViewModel.startDateFiltering {
                        calendarViewModel.startDateFiltering.toggle()
                    }
                    
                    letterBoxViewModel.fetchLetterBoxLetters()
                    letterBoxViewModel.fetchIsRead()
                }
            }
            .tint(.black)
            .buttonStyle(PlainButtonStyle())
            
            if showSearchBarView {
                VStack {
                    ZStack {
                        Color.clear
                            .background(Material.ultraThinMaterial)
                            .blur(radius: 1.5)

                        SearchBarView(searchText: $searchText, showSearchBarView: $showSearchBarView, isTextFieldFocused: $isTextFieldFocused, letterType: currentLetterType)
                            .padding(.top, 50)
                            .edgesIgnoringSafeArea(.top)
                            .zIndex(1)
                    }
                    .frame(maxHeight: .zero)
                    
                    Spacer()
                }
            }
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
