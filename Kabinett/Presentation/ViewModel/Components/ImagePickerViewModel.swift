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
    @Published var fromUserName: String = ""
    @Published var toUserName: String = ""
    @Published var date: Date = Date()
    @Published var postScript: String?
    @Published var envelopeURL: String?
    @Published var stampURL: String?
    @Published var fromUser: Writer? = nil
    @Published var toUser: Writer? = nil
    @Published var usersData: [Writer] = []
    @Published var fromUserSearchResults: [(name: String, kabinettNumber: String)] = []
    @Published var toUserSearchResults: [(name: String, kabinettNumber: String)] = []
    @Published var fromUserSearch: String = ""
    @Published var toUserSearch: String = ""
    @Published var debouncedSearchText: String = ""
    @Published var userKabiNumber: String?
    @Published var fromUserId: String?
    @Published var toUserId: String?
    @Published var searchText: String = ""
    @Published var checkLogin: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let componentsUseCase: ComponentsUseCase
    private let componentsLoadStuffUseCase: ComponentsLoadStuffUseCase
    private let firebaseFirestoreManager: FirebaseFirestoreManager
    
    init(componentsUseCase: ComponentsUseCase,
         componentsLoadStuffUseCase: ComponentsLoadStuffUseCase,
         firebaseFirestoreManager: FirebaseFirestoreManager) {
        self.componentsUseCase = componentsUseCase
        self.componentsLoadStuffUseCase = componentsLoadStuffUseCase
        self.firebaseFirestoreManager = firebaseFirestoreManager
        
        setupBindings()
        Task { [weak self] in
            await self?.fetchCurrentWriter()
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. mm. dd "
        return formatter.string(from: date)
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
        
        let results = await firebaseFirestoreManager.findWriter(by: query)
        self.usersData = results
        self.toUserSearchResults = results.map { (name: $0.name, kabinettNumber: String(format: "%06d", $0.kabinettNumber)) }
    }
    
    
    func updateSelectedUser(_ letterContent: inout LetterWriteModel, selectedUserName: String) {
        if let user = usersData.first(where: { $0.name == selectedUserName }) {
            toUser = Writer(id: user.id, name: user.name, kabinettNumber: user.kabinettNumber, profileImage: user.profileImage)
        } else {
            toUser = Writer(name: selectedUserName, kabinettNumber: 0, profileImage: nil)
        }
        letterContent.toUserId = toUser?.id
        letterContent.toUserName = toUser?.name ?? ""
        letterContent.toUserKabinettNumber = toUser?.kabinettNumber
        self.toUserName = selectedUserName
    }
    
    func isCurrentUser(kabiNumber: Int) -> String {
        fromUser?.kabinettNumber == kabiNumber ? "(나)" : ""
    }
    
    func updateCurrentUser() {
        if let fromUser = fromUser {
            if fromUser.kabinettNumber == 0 {
                checkLogin = false
            } else {
                checkLogin = true
            }
            toUser = fromUser
        }
    }
    
    @MainActor
    func fetchCurrentWriter() async {
        let publisher = await firebaseFirestoreManager.getCurrentWriter()
        for await result in publisher.values {
            self.fromUser = result
            self.fromUserName = result.name
            self.userKabiNumber = String(format: "%06d", result.kabinettNumber)
            self.fromUserId = result.id
            updateCurrentUser()
            var letterContent = LetterWriteModel()
            updateSelectedUser(&letterContent, selectedUserName: result.name)
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
            let envelopes = try await componentsLoadStuffUseCase.loadEnvelopes().get()
            let stamps = try await componentsLoadStuffUseCase.loadStamps().get()
            
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
        let result = await componentsUseCase.saveLetter(
            postScript: postScript,
            envelope: envelopeURL ?? "",
            stamp: stampURL ?? "",
            fromUserId: fromUserId,
            fromUserName: fromUserName,
            fromUserKabinettNumber: Int(userKabiNumber ?? "0"),
            toUserId: toUser?.id,
            toUserName: toUser?.name ?? "",
            toUserKabinettNumber: toUser?.kabinettNumber,
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
            self.error = error
            isLoading = false
            return false
        }
    }
    
    // MARK: - Methods (편지 저장 후 초기화)
    func resetState() {
        photoContents = []
        selectedItems = []
    }
}
