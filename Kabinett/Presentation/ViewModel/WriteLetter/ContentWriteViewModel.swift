//
//  WriteLetterViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/22/24.
//

import SwiftUI
import PhotosUI
import Combine

class ContentWriteViewModel: ObservableObject {
    @Published var offset: CGFloat = 0
    
    @Published var texts: [String] = [""]
    @Published var currentIndex: Int = 0
    @Published var isDeleteAlertPresented = false
    
    @Published var showFontMenu: Bool = false
    @Published var isFontEdit: Bool = true
    @Published var isKeyboard: Bool = false
    
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var photoContents: [Data] = []
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    @Published var isDeletePhoto: Bool = false
    @Published var showCheckmark: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func toggleFontView() {
        showFontMenu.toggle()
    }
    
    func createNewLetter(idx: Int) {
        texts.insert("", at: idx+1)
    }
    
    func deleteLetter(idx: Int) {
        if texts.count > 1 {
            texts.remove(at: idx)
        }
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
