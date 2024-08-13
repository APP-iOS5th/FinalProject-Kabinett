//
//  UserSelectionViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/13/24.
//
import Foundation
import SwiftUI
import Combine

struct userStruct {
    var ID: Int
    var name: String
    var image: String?
}

class UserSelectionViewModel: ObservableObject {
    @Published var checkLogin: Bool = true
    @Published var fromUser: String = "Song(나)"
    @Published var toUser: String = "Song(나)"
    
    @Published var dummyUsers: [userStruct] = [
        userStruct(ID: 111111, name: "User1", image: nil),
        userStruct(ID: 111112, name: "User2", image: nil),
        userStruct(ID: 111113, name: "User3", image: nil),
        userStruct(ID: 111114, name: "User4", image: nil),
        userStruct(ID: 111115, name: "User5", image: nil),
        userStruct(ID: 111116, name: "User6", image: nil),
        userStruct(ID: 111117, name: "User7", image: nil),
        userStruct(ID: 111218, name: "User8", image: nil),
        userStruct(ID: 111119, name: "User9", image: nil),
        userStruct(ID: 211110, name: "User10", image: nil)
        ]
    
}
