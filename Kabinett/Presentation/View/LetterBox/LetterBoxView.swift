//
//  LetterBoxView.swift
//  Kabinett
//
//  Created by uunwon on 8/13/24.
//

import SwiftUI
import FirebaseAnalytics

struct LetterBoxView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    @StateObject private var letterBoxViewModel: LetterBoxViewModel
    @StateObject private var letterBoxDetailViewModel: LetterBoxDetailViewModel
    
    @StateObject private var calendarViewModel = CalendarViewModel()
    @StateObject private var searchBarViewModel = SearchBarViewModel()
    @StateObject private var toastViewModel = ToastViewModel()
    
    @ObservedObject var customTabViewModel: CustomTabViewModel
    
    init(customTabViewModel: CustomTabViewModel) {
        self.customTabViewModel = customTabViewModel
        
        @Injected(LetterBoxUseCaseKey.self) var letterBoxUseCase: LetterBoxUseCase
        _letterBoxViewModel = StateObject(wrappedValue: LetterBoxViewModel(letterBoxUseCase: letterBoxUseCase))
        
        _letterBoxDetailViewModel = StateObject(wrappedValue: LetterBoxDetailViewModel(letterBoxUseCase: letterBoxUseCase))
    }
    
    var body: some View {
        ZStack {
            NavigationStack(path: $customTabViewModel.letterBoxNavigationPath) {
                ZStack {
                    Color.background
                        .ignoresSafeArea()
                    
                    LazyVGrid(columns: gridItems(), spacing: LayoutHelper.shared.getSize(forSE: 0.039, forOthers: 0.039)) {
                        ForEach(LetterType.allCases, id: \.self) { type in
                            let unreadCount = letterBoxViewModel.getIsReadLetters(for: type)
                            
                            NavigationLink(value: type) {
                                LetterBoxCell(viewModel: letterBoxViewModel, type: type, unreadCount: unreadCount)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                letterBoxDetailViewModel.currentLetterType = type
                            })
                        }
                    }
                    .padding(.top, LayoutHelper.shared.getSize(forSE: 0.035, forOthers: 0.035))
                    .navigationDestination(for: LetterType.self) { type in
                        LetterBoxDetailView(viewModel: letterBoxDetailViewModel, calendarViewModel: calendarViewModel, searchBarViewModel: searchBarViewModel)
                            .onAppear {
                                letterBoxDetailViewModel.currentLetterType = type
                            }
                    }
                    
                    VStack {
                        Spacer()
                        ToastView(toastViewModel: toastViewModel)
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
            .analyticsScreen(
                name: "\(type(of:self))",
                extraParameters: [
                    AnalyticsParameterScreenName: "\(type(of:self))",
                    AnalyticsParameterScreenClass: "\(type(of:self))",
                ]
            )
            
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
