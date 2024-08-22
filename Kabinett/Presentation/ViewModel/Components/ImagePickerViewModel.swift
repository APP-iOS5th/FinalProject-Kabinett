//
//  ImagePickerViewModel.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI

class ImagePickerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var fromUserName: String = ""
    @Published var toUserName: String = ""
    @Published var postScript: String?
    @Published var date: Date = Date()
    @Published var photoContents: [String] = []
    
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            Task {
                await loadImages()
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    // MARK: - Private Properties
    private let componentsUseCase: ComponentsUseCase
    
    // MARK: - Initializer
    init(componentsUseCase: ComponentsUseCase) {
        self.componentsUseCase = componentsUseCase
    }
    
    // MARK: - Image Loading
    @MainActor
    private func loadImages() async {
        isLoading = true
        error = nil
        
        do {
            let newImageContents = try await withThrowingTaskGroup(of: String?.self) { group -> [String] in
                for item in selectedItems {
                    group.addTask {
                        do {
                            let data = try await item.loadTransferable(type: Data.self)
                            if let data = data,
                               let uiImage = UIImage(data: data),
                               let jpegData = uiImage.jpegData(compressionQuality: 0.7) {
                                return jpegData.base64EncodedString()
                            }
                        } catch {
                            print("Failed to load image: \(error)")
                        }
                        return nil
                    }
                }
                
                var results: [String] = []
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
    
    // MARK: - Request to Save Letter Data
    func saveLetterToFirestore() async {
        isLoading = true
        error = nil
        
        let result = await componentsUseCase.saveLetter(
            postScript: postScript,
            envelope: "default_envelope",
            stamp: "default_stamp",
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
                resetState()
            case .failure(let error):
                self.error = error
            }
            isLoading = false
        }
    }
    
    // MARK: - Methods (편지 저장 후 초기화)
    private func resetState() {
        fromUserName = ""
        toUserName = ""
        postScript = nil
        date = Date()
        photoContents = []
        selectedItems = []
    }
}
