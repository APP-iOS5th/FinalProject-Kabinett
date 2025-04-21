//
//  FirestoreWidgetManager.swift
//  Kabinett
//
//  Created by Jihye Seok on 4/18/25.
//

import Foundation
import FirebaseFirestore
import os
import Combine

final class FirestoreWidgetManager {
    private let logger: Logger
    private let db = Firestore.firestore()
    
    //    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "FirestoreWidgetManager"
        )
    }
    
    func getWidgetLetter(userId: String, letterType: WidgetLetterType) -> AnyPublisher<[WidgetLetter], Never> {
        let subject = PassthroughSubject<[WidgetLetter], Never>()
        
        db.collection("Writers")
            .document(userId)
            .collection(letterType.rawValue)
            .whereField("isRead", isEqualTo: false)
            .order(by: "date", descending: true)
            .limit(to: 3)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    subject.send([])
                    return
                }
                let letters = documents.compactMap { doc -> WidgetLetter? in
                    try? doc.data(as: WidgetLetter.self)
                }
                subject.send(letters)
            }
        return subject.eraseToAnyPublisher()
    }
}
