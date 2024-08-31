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
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var fromUserName: String = ""
    @Published var toUserName: String = ""
    @Published var date: Date = Date()
    @Published var postScript: String?
    @Published var envelopeURL: String?
    @Published var stampURL: String?
    @Published var fromUser: String?
    @Published var toUser: String?
    @Published var fromUserSearchResults: [String] = []
    @Published var toUserSearchResults: [String] = []
    @Published var fromUserSearch: String = ""
    @Published var toUserSearch: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let mockWriter: MockWriter
    private let componentsUseCase: ComponentsUseCase
    private let componentsLoadStuffUseCase: ComponentsLoadStuffUseCase
    
    init(componentsUseCase: ComponentsUseCase,
         componentsLoadStuffUseCase: ComponentsLoadStuffUseCase,
         writerRepository: MockWriter = MockWriter()) {
        self.componentsUseCase = componentsUseCase
        self.componentsLoadStuffUseCase = componentsLoadStuffUseCase
        self.mockWriter = writerRepository
        
        setupBindings()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
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
    
    
    func loadEnvelopeAndStamp() async {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        do {
            let envelopes = try await componentsLoadStuffUseCase.loadEnvelopes().get()
            let stamps = try await componentsLoadStuffUseCase.loadStamps().get()
            
            await MainActor.run {
                if let firstEnvelope = envelopes.first {
                    self.envelopeURL = firstEnvelope
                    print("Envelope URL set to: \(firstEnvelope)")
                }
                if let firstStamp = stamps.first {
                    self.stampURL = firstStamp
                    print("Stamp URL set to: \(firstStamp)")
                }
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                isLoading = false
                print("Failed to load envelope and stamp: \(error)")
            }
        }
    }
    
    
    // MARK: - Request to Save Letter Data
    func saveImportingImage() async {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        print("Saving letter to Firebase")
        print("From: \(fromUserName)")
        print("To: \(toUserName)")
        print("Date: \(formattedDate)")
        print("Envelope: \(envelopeURL ?? "defaultEnvelope")")
        print("Stamp: \(stampURL ?? "defaultStamp")")
        print("Postscript: \(postScript ?? "")")
        print("Photo contents count: \(photoContents.count)")
        let result = await componentsUseCase.saveLetter(
            postScript: postScript,
            envelope: envelopeURL ?? "defaultEnvelope",
            stamp: stampURL ?? "defaultStamp",
            fromUserId: nil,
            fromUserName: fromUserName,
            fromUserKabinettNumber: nil,
            toUserId: nil,
            toUserName: toUserName,
            toUserKabinettNumber: nil,
            photoContents: photoContents,
            date: date,
            isRead: false
        )
        
        await MainActor.run {
            switch result {
            case .success:
                print("Letter saved successfully")
                resetState()
            case .failure(let error):
                print("Failed to save letter: \(error)")
                self.error = error
            }
            isLoading = false
        }
    }
    
    
    // MARK: - Methods (편지 저장 후 초기화)
    private func resetState() {
        photoContents = []
        selectedItems = []
    }
    
    private func setupBindings() {
        $fromUserSearch
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchUsers(searchText: searchText, isFromUser: true)
            }
            .store(in: &cancellables)
        
        $toUserSearch
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchUsers(searchText: searchText, isFromUser: false)
            }
            .store(in: &cancellables)
    }
    
    private func searchUsers(searchText: String, isFromUser: Bool) {
        guard !searchText.isEmpty else {
            DispatchQueue.main.async {
                if isFromUser {
                    self.fromUserSearchResults = []
                } else {
                    self.toUserSearchResults = []
                }
            }
            return
        }
        
        mockWriter.searchWriters(with: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let writers):
                    if isFromUser {
                        self?.fromUserSearchResults = writers
                    } else {
                        self?.toUserSearchResults = writers
                    }
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    @MainActor
    func selectUser(_ userName: String, isFromUser: Bool) {
        if isFromUser {
            fromUserName = userName
            fromUserSearchResults = []
        } else {
            toUserName = userName
            toUserSearchResults = []
        }
    }
}



class MockWriter {
    func searchWriters(with searchText: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let mockWriters = ["John Doe", "Jane Smith", "Sam Smith", "Sara Johnson"]
        let filteredWriters = mockWriters.filter { $0.lowercased().contains(searchText.lowercased()) }
        completion(.success(filteredWriters))
    }
}
