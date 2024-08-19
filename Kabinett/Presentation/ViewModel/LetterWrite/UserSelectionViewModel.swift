//
//  UserSelectionViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/19/24.
//

import Foundation
import SwiftUI
import Combine

class UserSelectionViewModel: ObservableObject {
    @ObservedObject var dummyData = DummyData()
    @Published var loginUser: Int? = 111111
    @Published var checkLogin: Bool = false
    
    @Published var fromUser: String = ""
    @Published var toUser: String = ""
    
    init() {
        updateFromUser()
    }
    
    private func updateFromUser() {
        if loginUser == nil {
            checkLogin = false
        } else {
            checkLogin = true
            if let user = dummyData.dummyUsers.first(where: { $0.kabinettNumber == loginUser }) {
                fromUser = user.name + "(나)"
                toUser = user.name + "(나)"
            }
        }
    }
}
