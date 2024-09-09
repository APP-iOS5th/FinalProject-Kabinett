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
    
    @State var showSearchBarView: Bool = false
    @State var searchText: String = ""
    @State var isTextFieldFocused: Bool = false
    
//    let letters = Array(0...16) // dummy
//    let letters: [Int] = [] // empty dummy
    @State private var letters: [Letter] = []
    
    private var xOffsets: [CGFloat] {
        return [-8, 10, 6, -2, 16]
    }
    
    init(letterType: LetterType) {
        self.letterType = letterType
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    if showSearchBarView {
                        SearchBarView(searchText: $searchText, showSearchBarView: $showSearchBarView, isTextFieldFocused: $isTextFieldFocused, letterType: letterType)
                    } else {
                        NavigationBarView(titleName: letterType.description, isColor: false, toolbarContent: {
                            toolbarItems()
                        }, backAction: {
                            if calendarViewModel.startDateFiltering {
                                calendarViewModel.startDateFiltering.toggle()
                            }
                        })
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                    }
                    
                    if calendarViewModel.startDateFiltering {
                        CalendarBar(letterType: letterType)
                    }
                    
                    letterBoxDetailListView()
                }
                
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
            .navigationBarBackButtonHidden()
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
            Spacer()
            
            if !searchText.isEmpty || calendarViewModel.startDateFiltering {
                Text("검색 결과가 없습니다.")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.contentPrimary)
            } else {
                Text(letterType.setEmptyMessage())
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.contentPrimary)
            }
            
            Spacer()
        }
        else if viewModel.letterBoxDetailLetters.count < 3 {
            Spacer()
            
            VStack(spacing: 25) {
                ForEach(viewModel.letterBoxDetailLetters, id: \.id) { letter in
                    NavigationLink(destination: LetterBoxDetailLetterView(letterType: letterType, letter: letter)) {
                        LetterBoxDetailEnvelopeCell(letter: letter)
                    }
                }
            }
            
            Spacer()
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
                    }
                }
                .padding(.top, navigationBarHeight)
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
    
    func toolbarItems() -> some View {
        HStack {
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
                    .fontWeight(.medium)
                    .font(.system(size: 19))
                    .foregroundStyle(.contentPrimary)
            }
            .padding(.trailing, 3)
            
            Button {
                withAnimation {
                    calendarViewModel.showCalendarView = true
                    calendarViewModel.currentLetterType = letterType
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .fontWeight(.medium)
                    .font(.system(size: 19))
                    .foregroundStyle(.contentPrimary)
            }
        }
    }
}

//#Preview {
//    LetterBoxDetailView(letterType: .all, showSearchBarView: .constant(false), searchText: .constant(""), isTextFieldFocused: .constant(false))
//        .environmentObject(LetterBoxDetailViewModel())
//        .environmentObject(CalendarViewModel())
//}

struct NavigationBarHeightKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
