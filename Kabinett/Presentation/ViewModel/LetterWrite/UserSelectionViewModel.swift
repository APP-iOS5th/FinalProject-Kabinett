//
//  UserSelectionViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/19/24.
//

import Foundation
import Combine

class UserSelectionViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var debouncedSearchText: String = ""
    @Published var checkLogin: Bool = false
    @Published var userKabiNumber: Int? = nil
    
    @Published var fromUser: Writer? = nil
    @Published var toUser: Writer? = nil
    @Published var usersData: [Writer] = []
    
    func reset() {
        searchText = ""
        debouncedSearchText = ""
        checkLogin = false
        userKabiNumber = nil
        fromUser = nil
        toUser = nil
        usersData = []
        
        Task {
            await getCurrentWriter()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: LetterWriteUseCase
    
    init(useCase: LetterWriteUseCase) {
        self.useCase = useCase
        
        $searchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { text in
                self.debouncedSearchText = text
                Task {
                    await self.findWriter(query: text)
                }
            }
            .store(in: &cancellables)
        
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
    
    func updateToUser(_ letterContent: inout LetterWriteModel, toUserName: String) {
        if let user = usersData.first(where: { $0.name == toUserName }) {
            toUser = Writer(id: user.id, name: user.name, kabinettNumber: user.kabinettNumber, profileImage: user.profileImage)
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
    
    @MainActor
    func getCurrentWriter() async {
//        let result = Writer(id: "pJIHwmW2WylwoY4bgTRI", name: "Ssong", kabinettNumber: 111111, profileImage: nil)
        let result = await useCase.getCurrentWriter()
        self.fromUser = result
        self.userKabiNumber = result.kabinettNumber
        updateFromUser()
    }
    
    @MainActor
    func findWriter(query: String) async {
        let results = await useCase.findWriter(by: query)
        self.usersData = results
    }
}
