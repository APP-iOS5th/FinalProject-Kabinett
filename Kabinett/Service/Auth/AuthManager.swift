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
    
    init() {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "AuthManager"
        )
        observeCurrentAuthStatus()
        signInAnonymousIfNeeded()
    }
    
    func getCurrentUser() -> AnyPublisher<User?, Never> {
        currentUserSubject
            .eraseToAnyPublisher()
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("sign out error")
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
            Task {
                do {
                    try await Auth.auth().signInAnonymously()
                } catch {
                    logger.error("SignInAnonymously is failed.")
                }
            }
        }
    }
}

extension AuthManager {
    static var users: AsyncStream<User?> {
        AsyncStream { continuation in
            _ = Auth.auth().addStateDidChangeListener { auth, user in
                continuation.yield(user)
            }
        }
    }
}
