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
    
    func createWriterDocument(with writer: Writer, writerId: String) {
        do {
            try db.collection("Writer")
                .document(writerId)
                .setData(from: writer)
        } catch {
            logger.error("Create Error: \(error.localizedDescription)")
        }
    }
}
