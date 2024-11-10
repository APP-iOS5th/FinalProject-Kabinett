//
//  SearchBarViewModel.swift
//  Kabinett
//
//  Created by uunwon on 11/11/24.
//

import Foundation

class SearchBarViewModel: ObservableObject {
    @Published var startSearchFiltering = false
    @Published var showSearchBarView = false
    @Published var searchText = ""
    @Published var isTextFieldFocused = false
    
    func resetSearchFiltering() {
        startSearchFiltering = false
        showSearchBarView = false
        searchText = ""
        isTextFieldFocused = false
    }
}
