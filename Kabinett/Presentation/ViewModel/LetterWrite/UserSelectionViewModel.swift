//
//  UserSelectionViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/13/24.
//

import Foundation
import SwiftUI
import Combine

class UserSelectionViewModel: ObservableObject {
    
    @Published var loginUser: Int? = 111111
    @Published var checkLogin: Bool = true
    @Published var fromUser: String = ""
    @Published var toUser: String = ""
    
    @Published var dummyUsers: [Writer] = [
        Writer(name: "Alice", kabinettNumber: 111111, profileImage: nil),
        Writer(name: "Bob", kabinettNumber: 234234, profileImage: nil),
        Writer(name: "Charlie", kabinettNumber: 111112, profileImage: nil),
        Writer(name: "David", kabinettNumber: 111131, profileImage: nil),
        Writer(name: "Eve", kabinettNumber: 111141, profileImage: nil),
        Writer(name: "Frank", kabinettNumber: 111151, profileImage: nil),
        Writer(name: "Grace", kabinettNumber: 111161, profileImage: nil),
    ]
    
    @Published var dummyLetters: [Letter] = []
    
    init() {
        updateFromUser()
    }
    
    private func updateFromUser() {
        if let loginUser = loginUser {
            if let user = dummyUsers.first(where: { $0.kabinettNumber == loginUser }) {
                fromUser = user.name + "(나)"
                toUser = user.name + "(나)"
            }
        }
    }
}
