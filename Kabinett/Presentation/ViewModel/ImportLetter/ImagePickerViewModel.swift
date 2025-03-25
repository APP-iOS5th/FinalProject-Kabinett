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
    @Published var selectedItems: [PhotosPickerItem] = [] //*****
    @Published var photoContents: [Data] = []
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let componentsUseCase: ImportLetterUseCase
    
    init(componentsUseCase: ImportLetterUseCase) {
        self.componentsUseCase = componentsUseCase
    }
    
    func resetSelections() {
        selectedItems = []
        photoContents = []
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
}
