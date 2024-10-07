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
    
    @State private var navigationBarHeight: CGFloat = 0
    @State private var calendarBarHeight: CGFloat = 0
    
    @State var showSearchBarView: Bool = false
    @State var searchText: String = ""
    @State var isTextFieldFocused: Bool = false
    
    private var xOffsets: [CGFloat] {
        return [-8, 10, 6, -2, 16]
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                if showSearchBarView {
                    SearchBarView(searchText: $searchText, showSearchBarView: $showSearchBarView, isTextFieldFocused: $isTextFieldFocused, letterType: calendarViewModel.currentLetterType)
                } else {
                    NavigationBarView(titleName: calendarViewModel.currentLetterType.description, isColor: false, toolbarContent: {
                        toolbarItems()
                    }, backAction: {
                        if calendarViewModel.startDateFiltering {
                            calendarViewModel.startDateFiltering.toggle()
                        }
                    })
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    let height = geo.frame(in: .local).height
                                    self.navigationBarHeight = height
                                }
                        }
                    )
                }
                
                if calendarViewModel.startDateFiltering {
                    CalendarBar()
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        let height = geo.frame(in: .local).height
                                        self.calendarBarHeight = height
                                    }
                            }
                        )
                }
                
                Spacer()
            }
            .zIndex(1)
            
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
        .slideToDismiss(action: {
            if calendarViewModel.startDateFiltering {
                calendarViewModel.startDateFiltering.toggle()
            }
            
            if showSearchBarView {
                showSearchBarView.toggle()
            }
        })
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            if showSearchBarView {
                isTextFieldFocused = false
                viewModel.fetchSearchByKeyword(findKeyword: searchText, letterType: calendarViewModel.currentLetterType)
            } else if calendarViewModel.startDateFiltering {
                viewModel.fetchSearchByDate(letterType: calendarViewModel.currentLetterType, startDate: calendarViewModel.startDate, endDate: calendarViewModel.endDate)
            } else {
                viewModel.fetchLetterBoxDetailLetters(letterType: calendarViewModel.currentLetterType)
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
                Text(calendarViewModel.currentLetterType.setEmptyMessage())
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.contentPrimary)
            }
            
            Spacer()
        }
        else if viewModel.letterBoxDetailLetters.count < 3 {
            Spacer()
            
            VStack(spacing: 25) {
                ForEach(viewModel.letterBoxDetailLetters, id: \.id) { letter in
                    NavigationLink(destination: LetterView(letterType: calendarViewModel.currentLetterType, letter: letter)) {
                        LargeEnvelopeCell(letter: letter)
                    }
                }
            }
            
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: -75) {
                    ForEach(Array(zip(viewModel.letterBoxDetailLetters.indices, viewModel.letterBoxDetailLetters)), id: \.0) { idx, letter in
                        NavigationLink(destination: LetterView(letterType: calendarViewModel.currentLetterType, letter: letter)) {
                            if idx < 2 {
                                LargeEnvelopeCell(letter: letter)
                                    .padding(.bottom, idx == 0 ? 82 : 37)
                            } else {
                                LargeEnvelopeCell(letter: letter)
                                    .offset(x: xOffsets[idx % xOffsets.count], y: CGFloat(idx * 5))
                                    .zIndex(Double(idx))
                                    .padding(.bottom, idx % 3 == 1 ? 37 : 0)
                            }
                        }
                    }
                }
                .padding(.top, navigationBarHeight + (calendarViewModel.startDateFiltering ? calendarBarHeight : 0) + 20)
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
                        viewModel.fetchLetterBoxDetailLetters(letterType: calendarViewModel.currentLetterType)
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
            .padding(.trailing, 5)
            
            Button {
                withAnimation {
                    calendarViewModel.showCalendarView = true
                    calendarViewModel.currentLetterType = calendarViewModel.currentLetterType
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
