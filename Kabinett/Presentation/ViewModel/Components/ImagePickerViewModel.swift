//
//  ImagePickerViewModel.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI
import Combine

final class ImagePickerViewModel: ObservableObject {
    
    @Published var selectedItems: [PhotosPickerItem] = []
    
    @Published var photoContents: [Data] = []
    @Published var date: Date = Date()
    @Published var isRead: Bool = false
    
    @Published var postScript: String?
    @Published var envelopeURL: String?
    @Published var stampURL: String?
    
    @Published var fromUserId: String?
    @Published var fromUserName: String = ""
    @Published var fromUserKabinettNumber: Int? = nil
    
    @Published var toUserId: String?
    @Published var toUserName: String = ""
    @Published var toUserKabinettNumber: Int? = nil
    
    @Published var fromUserSearch: String = ""
    @Published var toUserSearch: String = ""
    @Published var debouncedSearchText: String = ""
    
    @Published var fromUser: Writer? = nil
    @Published var toUser: Writer? = nil
    @Published var usersData: [Writer] = []
    
    @Published var fromUserSearchResults: [(name: String, kabinettNumber: String)] = []
    @Published var toUserSearchResults: [(name: String, kabinettNumber: String)] = []
    @Published var userKabiNumber: String?
    
    @Published var checkLogin: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: Error?

    private var cancellables = Set<AnyCancellable>()
    private let componentsUseCase: ComponentsUseCase
    
    init(componentsUseCase: ComponentsUseCase) {
        self.componentsUseCase = componentsUseCase
        
        setupBindings()
        Task {
            await fetchCurrentWriter()
        }
    }
    
    private func setupBindings() {
        $fromUserSearch
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                Task { [weak self] in
                    await self?.searchUsers(query: text, isFromUser: true)
                }
            }
            .store(in: &cancellables)
        
        $toUserSearch
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                Task { [weak self] in
                    await self?.searchUsers(query: text, isFromUser: false)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: 현재 사용자 정보 업데이트
       func updateFromUser() {
           if let fromUser = fromUser {
               checkLogin = fromUser.kabinettNumber != 0
               fromUserId = fromUser.id
               fromUserName = fromUser.name
               fromUserKabinettNumber = fromUser.kabinettNumber
               userKabiNumber = String(format: "%06d", fromUser.kabinettNumber)
               
               if checkLogin {
                   toUser = fromUser
                   toUserId = fromUser.id
                   toUserName = fromUser.name
                   toUserKabinettNumber = fromUser.kabinettNumber
               } else {
                   toUser = nil
                   toUserId = nil
                   toUserName = ""
                   toUserKabinettNumber = nil
               }
           }
       }
    
    // MARK: 사용자 검색 기능
    @MainActor
    func searchUsers(query: String, isFromUser: Bool) async {
        guard !query.isEmpty else {
            if isFromUser {
                self.fromUserSearchResults = []
            } else {
                self.toUserSearchResults = []
            }
            return
        }
        
        let results = await componentsUseCase.findWriter(by: query)
        let formattedResults = results.map { (name: $0.name, kabinettNumber: String(format: "%06d", $0.kabinettNumber)) }
        
        if isFromUser {
            self.fromUserSearchResults = formattedResults
        } else {
            self.toUserSearchResults = formattedResults
        }
    }
    
    
    func updateSelectedUser(selectedUserName: String) {
        if let user = usersData.first(where: { $0.name == selectedUserName }) {
            toUser = Writer(id: user.id, name: user.name, kabinettNumber: user.kabinettNumber, profileImage: user.profileImage)
        } else {
            toUser = Writer(name: selectedUserName, kabinettNumber: 0, profileImage: nil)
        }
        self.toUserId = toUser?.id
        self.toUserName = toUser?.name ?? ""
        self.toUserKabinettNumber = toUser?.kabinettNumber
        
    }
    
    // MARK: 현재 사용자 여부 확인
    func isCurrentUser(kabiNumber: Int) -> String {
        fromUser?.kabinettNumber == kabiNumber ? "(나)" : ""
    }
    
    
    // MARK: 현재 로그인한 사용자 정보 가져오기
    @MainActor
       func fetchCurrentWriter() async {
           let publisher = componentsUseCase.getCurrentWriter()
           
           for await writer in publisher.values {
               self.fromUser = writer
               updateFromUser()
               break
           }
       }
    
    // MARK: 선택된 이미지 로드
    private func loadImagesTask() async throws -> [Data] {
        try await withThrowingTaskGroup(of: Data?.self) { group -> [Data] in
            for item in selectedItems {
                group.addTask {
                    do {
                        if let data = try await item.loadTransferable(type: Data.self) {
                            return data
                        }
                    } catch {
                        print("Failed to load image: \(error)")
                    }
                    return nil
                }
            }
            
            var results: [Data] = []
            for try await result in group {
                if let result = result {
                    results.append(result)
                }
            }
            return results
        }
    }
    
    @MainActor
    func loadImages() async {
        isLoading = true
        error = nil
        
        do {
            let newImageContents = try await loadImagesTask()
            self.photoContents = newImageContents
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func updatePostScript(_ postScript: String) {
        self.postScript = postScript
    }
    
    func updateEnvelopeAndStamp(envelope: String?, stamp: String?) {
        if let envelope = envelope {
            self.envelopeURL = envelope
        }
        if let stamp = stamp {
            self.stampURL = stamp
        }
    }
    
    @MainActor
    func loadAndUpdateEnvelopeAndStamp() async {
        isLoading = true
        error = nil
        
        do {
            let envelopes = try await componentsUseCase.loadEnvelopes().get()
            let stamps = try await componentsUseCase.loadStamps().get()
            
            if self.envelopeURL == nil, let firstEnvelope = envelopes.first {
                self.envelopeURL = firstEnvelope
            }
            if self.stampURL == nil, let firstStamp = stamps.first {
                self.stampURL = firstStamp
            }
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            print("Failed to load envelope and stamp: \(error)")
        }
    }
    
    // MARK: 편지저장
    @MainActor
    func saveImportingImage() async -> Bool {
        isLoading = true
        error = nil
        
        if fromUserId == nil || fromUserKabinettNumber == nil {
            await fetchCurrentWriter()
        }
        
        let result = await componentsUseCase.saveLetter(
            postScript: postScript,
            envelope: envelopeURL ?? "",
            stamp: stampURL ?? "",
            fromUserId: fromUserId,
            fromUserName: fromUserName,
            fromUserKabinettNumber: fromUserKabinettNumber ?? 0,
            toUserId: toUserId,
            toUserName: toUserName,
            toUserKabinettNumber: toUserKabinettNumber ?? 0,
            photoContents: photoContents,
            date: date,
            isRead: false
        )
        switch result {
        case .success:
            resetState()
            isLoading = false
            return true
        case .failure(let error):
            print("Failed to save letter: \(error)")
            self.error = error
            isLoading = false
            return false
        }
    }
    
    // MARK: Methods (편지 저장 후 초기화)
    func resetState() {
        selectedItems = []
        photoContents = []
        fromUserName = ""
        toUserName = ""
        date = Date()
        postScript = nil
        envelopeURL = nil
        stampURL = nil
    }
    
    func resetSelections() {
        selectedItems = []
        photoContents = []
        postScript = nil
        envelopeURL = nil
        stampURL = nil
        toUserId = nil
        toUserName = ""
        toUserKabinettNumber = nil
        toUserSearch = ""
        toUserSearchResults = []
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}
