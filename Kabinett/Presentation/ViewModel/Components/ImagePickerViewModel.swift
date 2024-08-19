//
//  ImagePickerViewModel.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI
import PhotosUI


struct IdentifiableImage: Identifiable, Equatable {
    let id = UUID()
    let image: UIImage
    
    static func == (lhs: IdentifiableImage, rhs: IdentifiableImage) -> Bool {
        lhs.id == rhs.id
    }
}


// MARK: - ViewModel
final class ImagePickerViewModel: ObservableObject {
    @Published var selectedImages: [IdentifiableImage] = []
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            Task {
                await loadImages()
            }
        }
    }
    
    
    // MARK: Methods
    
    func loadImages() async {
        let newImages: [IdentifiableImage] = await withTaskGroup(of: IdentifiableImage?.self) { group in
            for item in selectedItems {
                group.addTask {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        return IdentifiableImage(image: uiImage)
                    }
                    return nil
                }
            }
            var images: [IdentifiableImage] = []
            for await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
        await MainActor.run {
            selectedImages = newImages
        }
    }
    
    func addImage(_ image: UIImage) {
        selectedImages.append(IdentifiableImage(image: image))
    }
}
