//
//  LetterBoxDetailView.swift
//  Kabinett
//
//  Created by uunwon on 8/14/24.
//

import SwiftUI
import UIKit

struct LetterBoxDetailView: View {
    @EnvironmentObject var viewModel: LetterBoxDetailViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    @State var letterType: LetterType
    
    @State private var navigationBarHeight: CGFloat = 0
    
    @Binding var showSearchBarView: Bool
    @Binding var searchText: String
    @Binding var isTextFieldFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
//    let letters = Array(0...16) // dummy
//    let letters: [Int] = [] // empty dummy
    @State private var letters: [Letter] = []
    
    private var xOffsets: [CGFloat] {
        return [-8, 10, 6, -2, 16]
    }
    
    init(
         letterType: LetterType,
         showSearchBarView: Binding<Bool>,
         searchText: Binding<String>,
         isTextFieldFocused: Binding<Bool>
    ) {
        self.letterType = letterType
        self._showSearchBarView = showSearchBarView
        self._searchText = searchText
        self._isTextFieldFocused = isTextFieldFocused
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UITabBar.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                if calendarViewModel.startDateFiltering {
                    CalendarBar(letterType: letterType)
                        .zIndex(1)
                }
                
                letterBoxDetailListView()
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        Text("\(viewModel.letterBoxDetailLetters.count)")
                            .font(.custom("SFDisplay", size: 16))
                            .padding(.horizontal, 17)
                            .padding(.vertical, 6)
                            .foregroundStyle(.black)
                            .background(.black.opacity(0.2))
                            .background(TransparentBlurView(removeAllFilters: true))
                            .cornerRadius(20)
                            .padding()
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle(letterType.description)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButtonView(action: { dismiss() }))
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toolbar {
                toolbarItems()
            }
            .onAppear {
                if showSearchBarView {
                    isTextFieldFocused = false
                    viewModel.fetchSearchByKeyword(findKeyword: searchText, letterType: letterType)
                } else if calendarViewModel.startDateFiltering {
                    viewModel.fetchSearchByDate(letterType: letterType, startDate: calendarViewModel.startDate, endDate: calendarViewModel.endDate)
                } else {
                    viewModel.fetchLetterBoxDetailLetters(letterType: letterType)
                }
            }
        }
    }
    
    @ViewBuilder
    func letterBoxDetailListView() -> some View {
        if viewModel.letterBoxDetailLetters.isEmpty {
            Text(letterType.setEmptyMessage())
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.contentPrimary)
        }
        else if viewModel.letterBoxDetailLetters.count < 3 {
            VStack(spacing: 25) {
                ForEach(viewModel.letterBoxDetailLetters, id: \.id) { letter in
                    NavigationLink(destination: LetterBoxDetailLetterView(letterType: letterType, letter: letter)) {
                        LetterBoxDetailEnvelopeCell(letter: letter)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        if showSearchBarView {
                            searchText = ""
                            showSearchBarView.toggle()
                        }
                        
                        if calendarViewModel.startDateFiltering {
                            calendarViewModel.startDateFiltering.toggle()
                        }
                    })
                }
            }
        } else {
            ScrollView {
                LazyVStack(spacing: -75) {
                    ForEach(Array(zip(viewModel.letterBoxDetailLetters.indices, viewModel.letterBoxDetailLetters)), id: \.0) { idx, letter in
                        NavigationLink(destination: LetterBoxDetailLetterView(letterType: letterType, letter: letter)) {
                            if idx < 2 {
                                LetterBoxDetailEnvelopeCell(letter: letter)
                                    .padding(.bottom, idx == 0 ? 82 : 37)
                            } else {
                                LetterBoxDetailEnvelopeCell(letter: letter)
                                    .offset(x: xOffsets[idx % xOffsets.count], y: CGFloat(idx * 5))
                                    .zIndex(Double(idx))
                                    .padding(.bottom, idx % 3 == 1 ? 37 : 0)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            if showSearchBarView {
                                searchText = ""
                                showSearchBarView.toggle()
                            }
                            
                            if calendarViewModel.startDateFiltering {
                                calendarViewModel.startDateFiltering.toggle()
                            }
                        })
                    }
                }
                .padding(.top, navigationBarHeight)
                .padding(.top, calendarViewModel.startDateFiltering ? 40 : 0)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: NavigationBarHeightKey.self, value: geometry.safeAreaInsets.top + geometry.frame(in: .global).minY)
                    }
                )
            }
            .onPreferenceChange(NavigationBarHeightKey.self) { value in
                navigationBarHeight = value + 15
            }
        }
    }
    
    func toolbarItems() -> some ToolbarContent {
        return ToolbarItemGroup {
            Button {
                withAnimation {
                    if calendarViewModel.startDateFiltering {
                        calendarViewModel.startDateFiltering = false
                        calendarViewModel.startDate = Date()
                        calendarViewModel.endDate = Date()
                        viewModel.fetchLetterBoxDetailLetters(letterType: letterType)
                    }
                    showSearchBarView.toggle()
                    isTextFieldFocused = true
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.contentPrimary)
            }

            Button {
                withAnimation {
                    calendarViewModel.showCalendarView.toggle()
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.contentPrimary)
            }
            .padding(5)
        }
    }
}

#Preview {
    LetterBoxDetailView(letterType: .all, showSearchBarView: .constant(false), searchText: .constant(""), isTextFieldFocused: .constant(false))
        .environmentObject(LetterBoxDetailViewModel())
        .environmentObject(CalendarViewModel())
}

struct NavigationBarHeightKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct BackButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 17, height: 36)
                    .foregroundStyle(.contentPrimary)
                    .padding(.leading, 4)
            }
        }
    }
}
