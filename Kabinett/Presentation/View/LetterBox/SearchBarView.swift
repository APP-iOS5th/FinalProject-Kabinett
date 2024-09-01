//
//  SearchBarView.swift
//  Kabinett
//
//  Created by uunwon on 8/30/24.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var viewModel: LetterBoxDetailViewModel
    
    @Binding var searchText: String
    @Binding var showSearchBarView: Bool
    
    @Binding var isTextFieldFocused: Bool
    @FocusState private var textFieldFocused: Bool
    
    var letterType: LetterType
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .tint(.black)
                TextField("Search", text: $searchText)
                    .focused($textFieldFocused)
                    .onAppear {
                        textFieldFocused = isTextFieldFocused
                    }
                    .onChange(of: textFieldFocused) { _, newValue in
                        isTextFieldFocused = newValue
                    }
                    .onChange(of: searchText) { _, newValue in
                        if newValue.isEmpty {
                            viewModel.fetchLetterBoxDetailLetters(letterType: letterType)
                        } else {
                            viewModel.fetchSearchByKeyword(findKeyword: searchText, letterType: letterType)
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
            
            if !searchText.isEmpty {
                Button(action: {
                    withAnimation {
                        showSearchBarView.toggle()
                        self.searchText = ""
                        viewModel.fetchLetterBoxDetailLetters(letterType: letterType)
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.primary600)
                }
            } else {
                EmptyView()
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 15)
    }
}
