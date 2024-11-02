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
    
    @State var startSearchFiltering: Bool = false
    @State var showSearchBarView: Bool = false
    @State var searchText: String = ""
    @State var isTextFieldFocused: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color.background
                        .ignoresSafeArea()
                    
                    LazyVGrid(columns: gridItems(), spacing: LayoutHelper.shared.getSize(forSE: 0.039, forOthers: 0.039)) {
                        ForEach(LetterType.allCases, id: \.self) { type in
                            let unreadCount = letterBoxViewModel.getIsReadLetters(for: type)
                            
                            NavigationLink(destination: LetterBoxDetailView(startSearchFiltering: $startSearchFiltering, showSearchBarView: $showSearchBarView, searchText: $searchText, isTextFieldFocused: $isTextFieldFocused)) {
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
                    
                    if calendarViewModel.startDateFiltering {
                        calendarViewModel.resetDateFiltering()
                    }
                    
                    if startSearchFiltering {
                        startSearchFiltering = false
                        showSearchBarView = false
                        searchText = ""
                        isTextFieldFocused = false
                    }
                }
            }
            .tint(.contentPrimary)
            
            if showSearchBarView {
                VStack {
                    ZStack {
                        Color.clear
                            .background(Material.ultraThinMaterial)
                            .blur(radius: 1.5)
                        
                        SearchBarView(searchText: $searchText, showSearchBarView: $showSearchBarView, startSearchFiltering: $startSearchFiltering, isTextFieldFocused: $isTextFieldFocused, letterType: calendarViewModel.currentLetterType)
                            .padding(.top, 30)
                            .zIndex(1)
                    }
                    .frame(maxHeight: .zero)
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // TODO: VM로 데이터 관리하면 키보드 내려가도록 재설정
                    isTextFieldFocused = false
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
