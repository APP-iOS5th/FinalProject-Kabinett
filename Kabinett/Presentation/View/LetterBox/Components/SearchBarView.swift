//
//  SearchBarView.swift
//  Kabinett
//
//  Created by uunwon on 8/30/24.
//

import SwiftUI

struct SearchBarView: View {
    @ObservedObject var viewModel: LetterBoxDetailViewModel
    @ObservedObject var searchBarViewModel: SearchBarViewModel
    
    @FocusState private var textFieldFocused: Bool
    
    var letterType: LetterType
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .tint(.black)
                TextField("Search", text: $searchBarViewModel.searchText)
                    .focused($textFieldFocused)
                    .textInputAutocapitalization(.never)
                    .onAppear {
                        textFieldFocused = searchBarViewModel.isTextFieldFocused
                    }
                    .onChange(of: textFieldFocused) { _, newValue in
                        searchBarViewModel.isTextFieldFocused = newValue
                    }
                    .onChange(of: searchBarViewModel.searchText) { _, newValue in
                        if newValue.isEmpty {
                            viewModel.fetchLetterBoxDetailLetters(letterType: letterType)
                        } else {
                            viewModel.fetchSearchByKeyword(findKeyword: searchBarViewModel.searchText, letterType: letterType)
                        }
                    }
                    .foregroundStyle(.primary)
                Image(systemName: "mic.fill")
            }
            .padding(7)
            .foregroundStyle(.primary600)
            .background(.primary300.opacity(0.2))
            .background(TransparentBlurView(removeAllFilters: false))
            .cornerRadius(10)
            
            Button(action: {
                withAnimation {
                    searchBarViewModel.resetSearchFiltering()
                    viewModel.fetchLetterBoxDetailLetters(letterType: letterType)
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.primary600)
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 15)
    }
}
