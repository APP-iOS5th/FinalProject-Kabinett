//
//  LetterBoxView.swift
//  Kabinett
//
//  Created by uunwon on 8/13/24.
//

import SwiftUI

struct LetterBoxView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    @StateObject private var letterBoxViewModel: LetterBoxViewModel
    @StateObject private var letterBoxDetailViewModel: LetterBoxDetailViewModel
    
    @StateObject private var calendarViewModel = CalendarViewModel()
    @StateObject private var searchBarViewModel = SearchBarViewModel()
    
    init() {
        @Injected(LetterBoxUseCaseKey.self) var letterBoxUseCase: LetterBoxUseCase
        _letterBoxViewModel = StateObject(wrappedValue: LetterBoxViewModel(letterBoxUseCase: letterBoxUseCase))
        
        _letterBoxDetailViewModel = StateObject(wrappedValue: LetterBoxDetailViewModel(letterBoxUseCase: letterBoxUseCase))
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color.background
                        .ignoresSafeArea()
                    
                    LazyVGrid(columns: gridItems(), spacing: LayoutHelper.shared.getSize(forSE: 0.039, forOthers: 0.039)) {
                        ForEach(LetterType.allCases, id: \.self) { type in
                            let unreadCount = letterBoxViewModel.getIsReadLetters(for: type)
                            
                            NavigationLink(destination: LetterBoxDetailView(viewModel: letterBoxDetailViewModel, calendarViewModel: calendarViewModel, searchBarViewModel: searchBarViewModel)) {
                                LetterBoxCell(viewModel: letterBoxViewModel, type: type, unreadCount: unreadCount)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                letterBoxDetailViewModel.currentLetterType = type
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
                    
                    if searchBarViewModel.startSearchFiltering {
                        searchBarViewModel.resetSearchFiltering()
                    }
                }
            }
            .tint(.contentPrimary)
            
            if searchBarViewModel.showSearchBarView {
                VStack {
                    ZStack {
                        Color.clear
                            .background(Material.ultraThinMaterial)
                            .blur(radius: 1.5)
                        
                        SearchBarView(viewModel: letterBoxDetailViewModel, searchBarViewModel: searchBarViewModel, letterType: letterBoxDetailViewModel.currentLetterType)
                            .padding(.top, 30)
                            .zIndex(1)
                    }
                    .frame(maxHeight: .zero)
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    searchBarViewModel.isTextFieldFocused = false
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
