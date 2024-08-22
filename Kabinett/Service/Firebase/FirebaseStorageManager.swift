//
//  FirebaseStorageManager.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/21/24.
//

import Foundation
import FirebaseStorage

final class FirebaseStorageManager: LetterWriteLoadStuffUseCase, ComponentsLoadStuffUseCase {
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
