//
//  UserSelectionViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/19/24.
//

import Foundation
import SwiftUI

class UserSelectionViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var checkLogin: Bool = false
    @Published var userKabiNumber: Int? = nil
    
    @Published var fromUser: Writer? = nil
    @Published var toUser: Writer? = nil
    @Published var dummyUsers: [Writer] = [
        Writer(name: "Alice", kabinettNumber: 111111, profileImage: nil),
        Writer(name: "Bob", kabinettNumber: 234234, profileImage: nil),
        Writer(name: "Charlie", kabinettNumber: 1112, profileImage: nil),
        Writer(name: "David", kabinettNumber: 11131, profileImage: nil),
        Writer(name: "Eve", kabinettNumber: 114141, profileImage: nil),
        Writer(name: "Frank", kabinettNumber: 1151, profileImage: nil),
        Writer(name: "Grace", kabinettNumber: 111161, profileImage: nil),
    ]
    
    private let useCase: LetterWriteUseCase

    init(useCase: LetterWriteUseCase) {
        self.useCase = useCase
        Task {
            await getCurrentWriter()
        }
    }
    
    func updateFromUser() {
        if let fromUser = fromUser {
            if fromUser.kabinettNumber == 0 {
                checkLogin = false
            } else {
                checkLogin = true
            }
            toUser = fromUser
        }
    }
    
    func updateToUser(_ letterContent: inout LetterWriteViewModel, toUserName: String) {
        if let user = dummyUsers.first(where: { $0.name == toUserName }) {
            toUser = Writer(name: user.name, kabinettNumber: user.kabinettNumber, profileImage: user.profileImage)
        } else {
            toUser = Writer(name: toUserName, kabinettNumber: 0, profileImage: nil)
        }
        letterContent.toUserId = toUser?.id
        letterContent.toUserName = toUser?.name ?? ""
        letterContent.toUserKabinettNumber = toUser?.kabinettNumber
    }
    
    func checkMe(kabiNumber: Int) -> String {
        fromUser?.kabinettNumber == kabiNumber ? "(나)" : ""
    }
    
    private func getCurrentWriter() async {
        let dummyWriter = Writer(name: "User", kabinettNumber: 0, profileImage: nil)
        self.fromUser = dummyWriter
        self.userKabiNumber = dummyWriter.kabinettNumber
        updateFromUser()
    }
}
