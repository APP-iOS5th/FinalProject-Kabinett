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
    
    // MARK: - Properties
    private let logger: Logger
    private var currentUserSubject: CurrentValueSubject<User?, Never> = .init(nil)
    private let writerManager: FirestoreWriterManager
    
    private var task: Task<Void, Never>?
    
    init(writerManager: FirestoreWriterManager) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "AuthManager"
        )
        self.writerManager = writerManager
        
        observeCurrentAuthStatus()
    }
    
    deinit {
        task?.cancel()
    }
    
    // MARK: - Public Methods
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
        nonce: String,
        provider: AuthProviderID = .apple
    ) async -> UserInfo {
        let credential = OAuthProvider.credential(
            providerID: provider,
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        guard let user = getCurrentUser() else {
            logger.warning("Attempting to linking account without current user is not allowed.")
            return .newUser
        }
    
        do {
            let result = try await user.link(with: credential)
            currentUserSubject.send(result.user)
            
            return .newUser
        } catch {
            let error = error as NSError
            let code = AuthErrorCode(rawValue: error.code)
            
            if code == .credentialAlreadyInUse {
                logger.debug("This credential already in use, delete current user and retry signing.")
                
                let existingUser = await signInWith(credential: credential)
                await deleteAccount(of: user)
                
                return .existingUser(existingUser)
            } else {
                logger.debug("Linking Error: \(error.localizedDescription)")
                
                return .newUser
            }
        }
    }
    
    func deleteAccount(of user: User) async {
        do {
            try await writerManager.deleteUserData(user.uid)
            try await user.delete()
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
        task = Task { [weak self] in
            for await user in AuthManager.users {
                if user == nil {
                    self?.signInAnonymousIfNeeded()
                }
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
            let listener = Auth.auth().addStateDidChangeListener { auth, user in
                continuation.yield(user)
            }
            
            continuation.onTermination = { _ in
                Auth.auth().removeStateDidChangeListener(listener)
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
