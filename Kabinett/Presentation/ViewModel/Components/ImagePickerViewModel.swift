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
    @Published var fromUser: Writer?
    @Published var toUser: Writer?
    @Published var fromUserSearchResults: [Writer] = []
    @Published var toUserSearchResults: [Writer] = []
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
    @MainActor
    func loadImages() async {
        isLoading = true
        error = nil
        
        do {
            let newImageContents = try await withThrowingTaskGroup(of: Data?.self) { group -> [Data] in
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
            
            self.photoContents = newImageContents
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    
    @MainActor
    func loadEnvelopeAndStamp() async {
        isLoading = true
        error = nil
        
        do {
            _ = try await componentsLoadStuffUseCase.loadEnvelopes().get()
            _ = try await componentsLoadStuffUseCase.loadStamps().get()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    
    // MARK: - Request to Save Letter Data
    func saveImportingImage() async {
        isLoading = true
        error = nil
        
        let result = await componentsUseCase.saveLetter(
            postScript: postScript,
            envelope: envelopeURL ?? "default_envelope",
            stamp: stampURL ?? "default_stamp",
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
            if isFromUser {
                fromUserSearchResults = []
            } else {
                toUserSearchResults = []
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
    
    func selectUser(_ writer: Writer, isFromUser: Bool) {
        if isFromUser {
            fromUser = writer
            fromUserName = writer.name
            fromUserSearchResults = []
        } else {
            toUser = writer
            toUserName = writer.name
            toUserSearchResults = []
        }
    }
}

class MockWriter {
    func searchWriters(with searchText: String, completion: @escaping (Result<[Writer], Error>) -> Void) {
        
        let mockWriters = [
            Writer(id: "1", name: "John Doe", kabinettNumber: 101-201, profileImage: nil),
            Writer(id: "2", name: "Jane Smith", kabinettNumber: 101-102, profileImage: nil)
        ]
        
        let filteredWriters = mockWriters.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        completion(.success(filteredWriters))
    }
}
