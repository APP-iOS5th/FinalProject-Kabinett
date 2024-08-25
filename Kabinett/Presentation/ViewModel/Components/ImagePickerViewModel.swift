//
//  ImagePickerViewModel.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI

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
    
    private let componentsUseCase: ComponentsUseCase
    private let componentsLoadStuffUseCase: ComponentsLoadStuffUseCase
    
    // MARK: - Initializer
    init(componentsUseCase: ComponentsUseCase, componentsLoadStuffUseCase: ComponentsLoadStuffUseCase) {
        self.componentsUseCase = componentsUseCase
        self.componentsLoadStuffUseCase = componentsLoadStuffUseCase
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
            let envelopes = try await componentsLoadStuffUseCase.loadEnvelopes().get()
            let stamps = try await componentsLoadStuffUseCase.loadStamps().get()
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
}
