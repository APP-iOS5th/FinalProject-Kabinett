//
//  ServiceKeys.swift
//  Kabinett
//
//  Created by jinwoong Kim on 10/6/24.
//

import Foundation

// MARK: - The Keys of Services
/// Note.
/// All objects of data layer are concret type.
/// In contrast, the objects of other layers
/// are existential type.
struct AuthManagerKey: InjectionKey {
    typealias Value = AuthManager
}

struct FirestoreWriterManagerKey: InjectionKey {
    typealias Value = FirestoreWriterManager
}

struct FirestoreLetterManagerKey: InjectionKey {
    typealias Value = FirestoreLetterManager
}

struct FirestorageWriterManagerKey: InjectionKey {
    typealias Value = FirestorageWriterManager
}

struct FirestorageLetterManagerKey: InjectionKey {
    typealias Value = FirestorageLetterManager
}
