//
//  DefaultProfileUseCase.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/18/24.
//

import Foundation
import Combine
import os

final class DefaultProfileUseCase {
    // MARK: - Properties
    private let logger: Logger
    
    private let authManager: AuthManager
    private let writerManager: FirestoreWriterManager
    private let writerStorageManager: FirestorageWriterManager
    
    private var disposableBag: Set<AnyCancellable> = []
    
    init(
        authManager: AuthManager,
        writerManager: FirestoreWriterManager,
        writerStorageManager: FirestorageWriterManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultProfileUseCase"
        )
        self.authManager = authManager
        self.writerManager = writerManager
        self.writerStorageManager = writerStorageManager
    }
}

// MARK: - Public Methods
extension DefaultProfileUseCase: ProfileUseCase {
    func getCurrentUserStatus() async -> AnyPublisher<UserStatus, Never> {
        authManager
            .getCurrentUser()
            .compactMap { $0 }
            .asyncMap { [weak self] user in
                if user.isAnonymous { return .anonymous }
                else {
                    return await self?.checkUserStatus(by: user.uid)
                }
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func getCurrentWriterPublisher() -> AnyPublisher<Writer, Never> {
        authManager
            .getCurrentUser()
            .compactMap { $0 }
            .asyncMap { [weak self] user in
                if user.isAnonymous { return .anonymousWriter }
                else {
                    return await self?.writerManager.getWriterDocument(with: user.uid)
                }
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func getAppleID() async -> String {
        authManager.getCurrentUser()?.email ?? ""
    }
    
    func updateWriter(newWriterName: String, profileImage: Data?) async -> Bool {
        guard let currentUser = authManager.getCurrentUser() else {
            logger.debug("There's no user.")
            return false
        }
        
        let currentWriter = await getCurrentWriter()
        
        let imageUrlString = await writerStorageManager
            .uploadProfileImage(
                with: profileImage,
                to: currentUser.uid
            )
        
        let updatedWriter = Writer(
            name: newWriterName,
            kabinettNumber: currentWriter.kabinettNumber,
            profileImage: imageUrlString
        )
        
        let result = writerManager.saveWriterDocument(
            with: updatedWriter,
            to: currentUser.uid
        )
        
        if result {
            authManager.updateUser(currentUser)
            return true
        } else {
            return false
        }
    }
    
    func signout() async -> Bool {
        authManager.signout()
    }
    
    func deleteId() async -> Bool {
        await authManager.deleteAccount(withSignIn: true)
        
        return true
    }
}

// MARK: - Private Methods
private extension DefaultProfileUseCase {
    func checkUserStatus(by userId: String) async -> UserStatus {
        let writer = await writerManager.getWriterDocument(with: userId)
        
        if writer.kabinettNumber == 0 {
            return .incomplete
        } else {
            return .registered
        }
    }
    
    func getCurrentWriter() async -> Writer {
        if let user = authManager.getCurrentUser() {
            return await writerManager.getWriterDocument(with: user.uid)
        } else {
            return .anonymousWriter
        }
    }
}
