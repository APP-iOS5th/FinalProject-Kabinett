//
//  FirestorageLetterManager.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/21/24.
//

import Foundation
import FirebaseStorage

final class FirestorageLetterManager: LetterWriteLoadStuffUseCase, ComponentsLoadStuffUseCase {
    let storage = Storage.storage()
    
    // 편지봉투 로딩
    func loadEnvelopes() async -> Result<[String], any Error> {
        await loadStorage(path: "Envelopes")
    }
    
    // 우표 로딩
    func loadStamps() async -> Result<[String], any Error> {
        await loadStorage(path: "Stamps")
    }
    
    // 편지지 로딩
    func loadStationeries() async -> Result<[String], any Error> {
        await loadStorage(path: "Stationeries")
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
    
    private func loadStorage(path: String) async -> Result<[String], any Error> {
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
}
