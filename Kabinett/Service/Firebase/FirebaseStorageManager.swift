//
//  FirebaseStorageManager.swift
//  Kabinett
//
//  Created by JIHYE SEOK on 8/21/24.
//

import Foundation
import FirebaseStorage

final class FirebaseStorageManager: LetterWriteLoadStuffUseCase, ComponentsLoadStuffUseCase, ObservableObject {
    let storage = Storage.storage()
    
    func loadEnvelopes() async -> Result<[String], any Error> {
        let envelopeRef = storage.reference().child("Envelopes")
        
        do {
            let envelopes = try await envelopeRef.listAll()
            var envelopeURLStrings: [String] = []
            for envelope in envelopes.items {
                let envelopeURL = try await envelope.downloadURL()
                envelopeURLStrings.append(envelopeURL.absoluteString)
            }
            
            return .success(envelopeURLStrings)
        } catch {
            return .failure(error)
        }
    }
    
    func loadStamps() async -> Result<[String], any Error> {
        // TODO: - stamp loading
        fatalError()
    }
    
    func loadStationeries() async -> Result<[String], any Error> {
        // TODO: - stationery loading
        fatalError()
    }
    
    
}
