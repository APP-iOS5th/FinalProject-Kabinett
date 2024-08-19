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
    @Published var dummyUsers: [Writer] = [
        Writer(name: "Alice", kabinettNumber: 111111, profileImage: "https://cdn.pixabay.com/photo/2022/06/25/13/33/landscape-7283516_1280.jpg"),
        Writer(name: "Bob", kabinettNumber: 234234, profileImage: nil),
        Writer(name: "Charlie", kabinettNumber: 111112, profileImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxjfCS04oKkgLWiCPCQg026DciIS5ayfvTg&s"),
        Writer(name: "David", kabinettNumber: 111131, profileImage: nil),
        Writer(name: "Eve", kabinettNumber: 1141, profileImage: nil),
        Writer(name: "Frank", kabinettNumber: 111151, profileImage: nil),
        Writer(name: "Grace", kabinettNumber: 111161, profileImage: nil),
    ]
    
    @Published var loginUserKabinett: Int? = 111111
    @Published var checkLogin: Bool = false
    
    @Published var fromUser: String = ""
    @Published var toUser: String = ""
    
    init() {
        updateFromUser()
    }
    
    private func updateFromUser() {
        if let user = dummyUsers.first(where: { $0.kabinettNumber == loginUserKabinett }) {
            checkLogin = true
            fromUser = user.name + "(나)"
            toUser = user.name + "(나)"
        } else {
            checkLogin = false
            fromUser = "나"
            toUser = "나"
        }
    }
}
