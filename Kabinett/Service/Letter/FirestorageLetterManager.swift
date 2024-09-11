//
//  FirestorageLetterManager.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/21/24.
//

import Foundation
import FirebaseStorage
import os

final class FirestorageLetterManager {
    let storage = Storage.storage()
    private let logger: Logger
    
    init() {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "FirestorageLetterManager"
        )
    }
    
    func convertPhotoToUrl(photoContents: [Data]) async throws -> [String] {
        let storageRef = storage.reference()
        
        return try await withThrowingTaskGroup(of: String.self) { taskGroup in
            var photoContentUrlStrings: [String] = []
            
            for photoContent in photoContents {
                taskGroup.addTask {
                    let photoRef = storageRef.child("Users/photoContents/\(UUID().uuidString).jpg")
                    
                    _ = try await photoRef.putDataAsync(photoContent, metadata: nil)
                    
                    let downloadURL = try await photoRef.downloadURL()
                    return downloadURL.absoluteString
                }
            }
            
            for try await urlString in taskGroup {
                photoContentUrlStrings.append(urlString)
            }
            
            return photoContentUrlStrings
        }
    }
    
    func loadStorage(path: String) async -> Result<[String], any Error> {
        let storageRef = storage.reference().child(path)
        
        do {
            let results = try await storageRef.listAll()
            var resultURLStrings: [String] = []
            for result in results.items {
                let resultURL = try await result.downloadURL()
                resultURLStrings.append(resultURL.absoluteString)
            }
            return .success(resultURLStrings)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteData(urls: [String], path: String) async throws {
        for url in urls {
            guard let fileName = extractFileName(from: url) else {
                logger.error("Failed to extract FileName: \(url)")
                throw NSError(domain: "DeleteDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to extract file name for URL: \(url)"])
            }

            let storageRef = storage.reference().child("\(path)/\(fileName)")
            try await storageRef.delete()
        }
    }

    private func extractFileName(from url: String) -> String? {
        guard let urlComponents = URLComponents(string: url),
              let filePath = urlComponents.path.components(separatedBy: "/").last,
              let decodedFilePath = filePath.removingPercentEncoding else {
            return nil
        }
        
        return decodedFilePath.components(separatedBy: "?").first ?? decodedFilePath
    }
}
