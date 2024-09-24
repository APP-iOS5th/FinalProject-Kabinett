//
//  FirestorageWriterManager.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/30/24.
//

import Foundation
import FirebaseStorage
import os

final class FirestorageWriterManager {
    private let storage = Storage.storage()
    private let logger: Logger
    
    init() {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "FirestorageWriterManager"
        )
    }
    
    func uploadProfileImage(with imageData: Data?, to userId: String) async -> String? {
        guard let imageData else { return nil }
        
        let imageRef = storage.reference(withPath: "profileImages/\(userId).png")
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        do {
            _ = try await imageRef.putDataAsync(imageData, metadata: metaData)
            return try await imageRef.downloadURL().absoluteString
        } catch {
            logger.error("Error occured: \(error.localizedDescription)")
            return nil
        }
    }
}
