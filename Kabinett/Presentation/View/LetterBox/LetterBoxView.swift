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
    
    let columns = [
        GridItem(.flexible(minimum: 220), spacing: -60),
        GridItem(.flexible(minimum: 220))
    ]
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color.background
                    
                    LazyVGrid(columns: columns, spacing: 40) {
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
                    
                    VStack {
                        if showToast {
                            Spacer()
                            ToastView(message: "카비넷 팀이 보낸 편지가 도착했습니다.", horizontalPadding: 50)
                                .transition(.move(edge: .bottom))
                                .zIndex(1)
                                .onAppear {
                                    letterBoxViewModel.fetchWelcomeLetter()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showToast = false
                                        }
                                    }
                                }
                                .padding(.bottom, 65)
                        }
                    }
                }
                .ignoresSafeArea()
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
}

//#Preview {
//    LetterBoxView()
//        .environmentObject(LetterBoxViewModel())
//        .environmentObject(CalendarViewModel())
//}
