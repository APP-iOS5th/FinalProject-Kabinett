//
//  LetterBoxDetailView.swift
//  Kabinett
//
//  Created by uunwon on 8/14/24.
//

import SwiftUI
import UIKit

struct LetterBoxDetailView: View {
    @ObservedObject var viewModel: LetterBoxDetailViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var searchBarViewModel: SearchBarViewModel
    
    @State private var navigationBarHeight: CGFloat = 0
    @State private var calendarBarHeight: CGFloat = 0
    
    private var xOffsets: [CGFloat] {
        return [-8, 10, 6, -2, 16]
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                if calendarViewModel.startDateFiltering {
                    CalendarBar(letterBoxDetailviewModel: viewModel, calendarViewModel: calendarViewModel)
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
        .navigationTitle(calendarViewModel.currentLetterType.description)
        .toolbarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .toolbar{ toolbarItems() }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .overlay(
            CalendarOverlayView(letterBoxDetailViewModel: viewModel, calendarViewModel: calendarViewModel)
        )
        .onAppear {
            if searchBarViewModel.startSearchFiltering {
                searchBarViewModel.showSearchBarView = true
                searchBarViewModel.isTextFieldFocused = false
                viewModel.fetchSearchByKeyword(findKeyword: searchBarViewModel.searchText, letterType: calendarViewModel.currentLetterType)
            } else if calendarViewModel.startDateFiltering {
                viewModel.fetchSearchByDate(letterType: calendarViewModel.currentLetterType, startDate: calendarViewModel.startDate, endDate: calendarViewModel.endDate)
            } else {
                viewModel.fetchLetterBoxDetailLetters(letterType: calendarViewModel.currentLetterType)
            }
        }
        .onDisappear {
            searchBarViewModel.showSearchBarView = false
        }
    }
    
    @ViewBuilder
    func letterBoxDetailListView() -> some View {
        if viewModel.letterBoxDetailLetters.isEmpty {
            Spacer()
            
            if searchBarViewModel.startSearchFiltering || calendarViewModel.startDateFiltering {
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
                        calendarViewModel.resetDateFiltering()
                        viewModel.fetchLetterBoxDetailLetters(letterType: calendarViewModel.currentLetterType)
                    }
                    searchBarViewModel.isTextFieldFocused = true
                    searchBarViewModel.startSearchFiltering.toggle()
                    searchBarViewModel.showSearchBarView.toggle()
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .fontWeight(.medium)
                    .foregroundStyle(.contentPrimary)
            }
            .padding(.trailing, -4)
            
            Button {
                withAnimation {
                    if searchBarViewModel.startSearchFiltering {
                        searchBarViewModel.resetSearchFiltering()
                        viewModel.fetchLetterBoxDetailLetters(letterType: calendarViewModel.currentLetterType)
                    }
                    calendarViewModel.showCalendarView.toggle()
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .fontWeight(.medium)
                    .foregroundStyle(.contentPrimary)
            }
        }
    }
}
