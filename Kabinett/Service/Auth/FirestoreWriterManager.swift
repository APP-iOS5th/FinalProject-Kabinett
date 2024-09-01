//
//  FirestoreWriterManager.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/17/24.
//

import Foundation
import FirebaseFirestore
import os

final class FirestoreWriterManager {
    private let db = Firestore.firestore()
    private let logger: Logger
    
    init() {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "FirestoreWriterManager"
        )
    }
    
    func saveWriterDocument(with writer: Writer, to writerId: String) -> Bool {
        do {
            try db.collection("Writers")
                .document(writerId)
                .setData(from: writer)
            return true
        } catch {
            logger.error("Create Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func getWriterDocument(with writerId: String) async -> Writer {
        do {
            return try await db.collection("Writers")
                .document(writerId)
                .getDocument(as: Writer.self)
        } catch {
            logger.error("No writer was not found: \(writerId, privacy: .private)")
            return .anonymousWriter
        }
    }
    
    func checkAvailability(of number: Int) async -> Bool {
        do {
            let result = try await db.collection("Writers")
                .whereField("kabinettNumber", isEqualTo: number)
                .limit(to: 1)
                .getDocuments()
            return result.isEmpty
        } catch {
            logger.error("Number checking Error: \(error)")
            return false
        }
    }
}
