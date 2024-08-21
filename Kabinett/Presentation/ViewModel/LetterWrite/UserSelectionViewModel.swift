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
    @Published var searchText: String = ""
    @Published var checkLogin: Bool = false
    @Published var userKabi: Int? = nil
    @Published var fromUser: Writer? = nil
    @Published var toUser: Writer? = nil
    
    @Published var dummyUsers: [Writer] = [
        Writer(id: "user_1", name: "Alice", kabinettNumber: 111111, profileImage: "https://cdn.pixabay.com/photo/2022/06/25/13/33/landscape-7283516_1280.jpg"),
        Writer(id: "user_2", name: "Bob", kabinettNumber: 234234, profileImage: nil),
        Writer(id: "user_3", name: "Charlie", kabinettNumber: 1112, profileImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxjfCS04oKkgLWiCPCQg026DciIS5ayfvTg&s"),
        Writer(id: "user_4", name: "David", kabinettNumber: 11131, profileImage: nil),
        Writer(id: "user_5", name: "Eve", kabinettNumber: 114141, profileImage: nil),
        Writer(id: "user_6", name: "Frank", kabinettNumber: 1151, profileImage: nil),
        Writer(id: "user_7", name: "Grace", kabinettNumber: 111161, profileImage: nil),
    ]
    
    init() {
        userKabi = 111111
        updateFromUser()
    }
    
    private func updateFromUser() {
        if let user = dummyUsers.first(where: { $0.kabinettNumber == userKabi }) {
            checkLogin = true
            fromUser = Writer(id: user.id, name: user.name, kabinettNumber: user.kabinettNumber, profileImage: user.profileImage)
        } else {
            checkLogin = false
            fromUser = Writer(name: "나", kabinettNumber: 0, profileImage: nil)
            toUser = Writer(name: "나", kabinettNumber: 0, profileImage: nil)
        }
    }
    
    func updateToUser(_ letterContent: inout LetterWriteViewModel, toUserName: String) {
        if let user = dummyUsers.first(where: { $0.name == toUserName }) {
            toUser = Writer(id: user.id, name: user.name, kabinettNumber: user.kabinettNumber, profileImage: user.profileImage)
            letterContent.toUserId = toUser?.id
            letterContent.toUserName = toUser?.name ?? ""
            letterContent.toUserKabinettNumber = toUser?.kabinettNumber
        } else {
            toUser = Writer(name: toUserName, kabinettNumber: 0, profileImage: nil)
            letterContent.toUserId = toUser?.id
            letterContent.toUserName = toUser?.name ?? ""
            letterContent.toUserKabinettNumber = toUser?.kabinettNumber
        }
    }
    
    func checkMe(kabi: Int) -> String {
        userKabi == kabi ? "(나)" : ""
    }
}
