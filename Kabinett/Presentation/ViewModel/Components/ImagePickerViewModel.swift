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
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let componentsUseCase: ComponentsUseCase
    
    init(componentsUseCase: ComponentsUseCase) {
        self.componentsUseCase = componentsUseCase
        
        setupBindings()
        Task { [weak self] in
            await self?.fetchCurrentWriter()
        }
    }
    func printCurrentState(label: String = "") {
        print("\n--- Current State \(label) ---")
        print("photoContents: \(photoContents.count) items")
        print("date: \(date)")
        print("isRead: \(isRead)")
        print("postScript: \(postScript ?? "nil")")
        print("envelopeURL: \(envelopeURL ?? "nil")")
        print("stampURL: \(stampURL ?? "nil")")
        print("fromUserId: \(fromUserId ?? "nil")")
        print("fromUserName: \(fromUserName)")
        print("fromUserKabinettNumber: \(fromUserKabinettNumber ?? 0)")
        print("toUserId: \(toUserId ?? "nil")")
        print("toUserName: \(toUserName)")
        print("toUserKabinettNumber: \(toUserKabinettNumber ?? 0)")
        print("fromUserSearch: \(fromUserSearch)")
        print("toUserSearch: \(toUserSearch)")
        print("debouncedSearchText: \(debouncedSearchText)")
        print("-------------------------")
    }
    
    private func setupBindings() {
        $toUserSearch
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.debouncedSearchText = text
                Task { [weak self] in
                    await self?.searchUsers(query: text)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func searchUsers(query: String) async {
        guard !query.isEmpty else {
            self.usersData = []
            self.toUserSearchResults = []
            return
        }
        
        let results = await componentsUseCase.findWriter(by: query)
        self.usersData = results
        self.toUserSearchResults = results.map { (name: $0.name, kabinettNumber: String(format: "%06d", $0.kabinettNumber)) }
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
            
            printCurrentState(label: "After updateSelectedUser")
        }
    
    func isCurrentUser(kabiNumber: Int) -> String {
        fromUser?.kabinettNumber == kabiNumber ? "(나)" : ""
    }
    
    
    
    @MainActor
    func fetchCurrentWriter() async {
        print("Starting fetchCurrentWriter...")
        let publisher = componentsUseCase.getCurrentWriter()
        
        for await user in publisher.values {
            print("Received user from getCurrentWriter: \(user)")
            self.fromUser = user
            self.fromUserId = user.id
            self.fromUserName = user.name
            self.fromUserKabinettNumber = user.kabinettNumber
            self.userKabiNumber = String(format: "%06d", user.kabinettNumber)
            
            print("Updated fromUser: \(String(describing: self.fromUser))")
            print("Updated fromUserId: \(String(describing: self.fromUserId))")
            print("Updated fromUserName: \(self.fromUserName)")
            print("Updated fromUserKabinettNumber: \(String(describing: self.fromUserKabinettNumber))")
            print("Updated userKabiNumber: \(String(describing: self.userKabiNumber))")
            
            
            print("Current user information fetched and updated:")
            printCurrentState(label: "After fetchCurrentWriter")
            break
        }
    }
    
    // MARK: - Image Loading
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
            
            if let firstEnvelope = envelopes.first {
                self.envelopeURL = firstEnvelope
            }
            if let firstStamp = stamps.first {
                self.stampURL = firstStamp
            }
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            print("Failed to load envelope and stamp: \(error)")
        }
    }
    
    // MARK: - Request to Save Letter Data
    @MainActor
        func saveImportingImage() async -> Bool {
            isLoading = true
            error = nil
            printCurrentState(label: "Before saveImportingImage")
            
            if fromUserId == nil || fromUserKabinettNumber == nil {
                await fetchCurrentWriter()
            }
            
            let result = await componentsUseCase.saveLetter(
                postScript: postScript,
                envelope: envelopeURL ?? "",
                stamp: stampURL ?? "",
                fromUserId: fromUserId,
                fromUserName: fromUserName,
                fromUserKabinettNumber: fromUserKabinettNumber,
                toUserId: toUserId,
                toUserName: toUserName,
                toUserKabinettNumber: toUserKabinettNumber,
                photoContents: photoContents,
                date: date,
                isRead: false
            )
            printCurrentState(label: "After saveImportingImage")
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
    
    // MARK: - Methods (편지 저장 후 초기화)
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
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}
