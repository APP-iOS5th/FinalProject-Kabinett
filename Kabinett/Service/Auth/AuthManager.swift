//
//  AuthManager.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/17/24.
//

import Foundation
import FirebaseAuth
import Combine
import os

final class AuthManager {
    private let logger: Logger
    private var currentUserSubject: CurrentValueSubject<User?, Never> = .init(nil)
    private let writerManager: FirestoreWriterManager
    
    init(writerManager: FirestoreWriterManager) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "AuthManager"
        )
        self.writerManager = writerManager
        
        observeCurrentAuthStatus()
        signInAnonymousIfNeeded()
    }
    
    func getCurrentUser() -> AnyPublisher<User?, Never> {
        currentUserSubject
            .eraseToAnyPublisher()
    }
    
    func signout() -> Bool {
        do {
            try Auth.auth().signOut()
            signInAnonymousIfNeeded()
            
            return true
        } catch {
            logger.error("Signout Error: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func linkAccount(
        with credential: OAuthCredential
    ) async -> Bool {
        do {
            if let user = Auth.auth().currentUser {
                let result = try await user.link(with: credential)
                currentUserSubject.send(result.user)
                
                return true
            } else {
                logger.warning("Attempting to linking user without current user is not allowed.")
                return false
            }
        } catch {
            let error = error as NSError
            let code = AuthErrorCode(rawValue: error.code)
            
            if code == .credentialAlreadyInUse {
                logger.debug("This credential already in use, delete current user and retry signing.")
                deleteAccount()
                await signInWith(credential: credential)
                
                return true
            } else {
                logger.debug("Linking Error: \(error.localizedDescription)")
                
                return false
            }
        }
    }
    
    func deleteAccount() {
        Auth.auth().currentUser?.delete()
    }
    
    private func signInWith(credential: AuthCredential) async {
        do {
            try await Auth.auth().signIn(with: credential)
        } catch {
            logger.error("signInWith Error: \(error)")
        }
    }
    
    private func observeCurrentAuthStatus() {
        Task { [weak self] in
            for await user in AuthManager.users {
                self?.currentUserSubject.send(user)
            }
        }
    }
    
    private func signInAnonymousIfNeeded() {
        if Auth.auth().currentUser == nil {
            Task { [weak self] in
                do {
                    let result = try await Auth.auth().signInAnonymously()
                    self?.writerManager.createWriterDocument(
                        with: .anonymousWriter,
                        writerId: result.user.uid
                    )
                } catch {
                    self?.logger.error("SignInAnonymously is failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

private extension AuthManager {
    static var users: AsyncStream<User?> {
        AsyncStream { continuation in
            _ = Auth.auth().addStateDidChangeListener { auth, user in
                continuation.yield(user)
            }
        }
    }
}

extension Writer {
    static let anonymousWriter = Writer(
        name: "User",
        kabinettNumber: 0,
        profileImage: nil
    )
}
