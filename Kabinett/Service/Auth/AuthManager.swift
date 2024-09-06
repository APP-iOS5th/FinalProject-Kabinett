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
    enum UserInfo {
        case newUser
        case existingUser(User?)
    }
    
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
    
    func getCurrentUser() -> User? {
        Auth.auth().currentUser
    }
    
    func signout() -> Bool {
        logger.debug("Attempt to sign out.")
        do {
            try Auth.auth().signOut()
            signInAnonymousIfNeeded()
            
            return true
        } catch {
            logger.error("Signout Error: \(error.localizedDescription)")
            
            return false
        }
    }
    
    // TODO: Change Method name
    // TODO: Add error handling
    func linkAccount(
        with idTokenString: String,
        nonce: String
    ) async -> UserInfo {
        let credential = OAuthProvider.credential(
            providerID: .apple,
            idToken: idTokenString,
            rawNonce: nonce
        )
    
        do {
            if let user = Auth.auth().currentUser {
                let result = try await user.link(with: credential)
                currentUserSubject.send(result.user)
                
                return .newUser
            } else {
                logger.warning("Attempting to linking account without current user is not allowed.")
                return .newUser
            }
        } catch {
            let error = error as NSError
            let code = AuthErrorCode(rawValue: error.code)
            
            if code == .credentialAlreadyInUse {
                logger.debug("This credential already in use, delete current user and retry signing.")
                await deleteAccount()
                let user = await signInWith(credential: credential)
                
                return .existingUser(user)
            } else {
                logger.debug("Linking Error: \(error.localizedDescription)")
                
                return .newUser
            }
        }
    }
    
    func deleteAccount(withSignIn: Bool = false) async {
        do {
            guard let currentUser = getCurrentUser() else {
                logger.error("Delete account without user is not allowed.")
                return
            }
            try await currentUser.delete()
            try await writerManager.deleteUserData(currentUser.uid)
            
            if withSignIn {
                logger.info("with sign in is true: \(Auth.auth().currentUser)")
                signInAnonymousIfNeeded()
            }
        } catch {
            logger.error("Delete account is failed: \(error.localizedDescription)")
        }
    }
    
    func updateUser(_ user: User) {
        currentUserSubject.send(user)
    }

    // MARK: - Private Methods
    private func signInWith(
        credential: AuthCredential
    ) async -> User? {
        do {
            return try await Auth.auth()
                .signIn(with: credential)
                .user
        } catch {
            logger.error("signInWith Error: \(error)")
            return nil
        }
    }
    
    private func observeCurrentAuthStatus() {
        Task { [weak self] in
            for await user in AuthManager.users {
                self?.logger.debug(
                    "User authentication state is changed: \(String(describing: user?.uid), privacy: .private)"
                )
                self?.currentUserSubject.send(user)
            }
        }
    }
    
    private func signInAnonymousIfNeeded() {
        if Auth.auth().currentUser == nil {
            logger.debug("There is no current user, attempt to sign in anonymously.")
            Task { [weak self] in
                do {
                    let result = try await Auth.auth().signInAnonymously()
                    _ = self?.writerManager.saveWriterDocument(
                        with: .anonymousWriter,
                        to: result.user.uid
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
