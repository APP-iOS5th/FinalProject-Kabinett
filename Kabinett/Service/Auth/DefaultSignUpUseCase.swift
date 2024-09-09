//
//  DefaultSignUpUseCase.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/31/24.
//

import Foundation
import AuthenticationServices
import os

final class DefaultSignUpUseCase {
    // MARK: - Properties
    private let logger: Logger
    
    private let authManager: AuthManager
    private let writerManager: FirestoreWriterManager
    
    init(
        authManager: AuthManager,
        writerManager: FirestoreWriterManager
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.Kabinett",
            category: "DefaultSignUpUseCase"
        )
        self.authManager = authManager
        self.writerManager = writerManager
    }
}

// MARK: - Public Methods
extension DefaultSignUpUseCase: SignUpUseCase {
    func getAvailableKabinettNumbers() async -> [Int] {
        var availableNumbers: [Int] = []
        
        while true {
            let randomNumber = Int.random(in: 1..<1_000_000)
            if await writerManager.checkAvailability(of: randomNumber) {
                availableNumbers.append(randomNumber)
            }
            if availableNumbers.count == 3 { break }
        }
        
        return availableNumbers
    }
    
    func signUp(with authorization: ASAuthorization, nonce: String) async -> SignUpResult {
        guard let appleIDCrendential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            logger.error("This Credential is not valid.")
            return .newUser
        }
        guard let appleIDToken = appleIDCrendential.identityToken else {
            logger.error("Cannot fetch id token from crendential.")
            return .newUser
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            logger.error("Cannot parse id token string from toke: \(appleIDToken.debugDescription)")
            return .newUser
        }
        let result = await authManager.linkAccount(with: idTokenString, nonce: nonce)
        
        switch result {
        case .newUser:
            return .newUser
        case let .existingUser(user):
            let writer = await writerManager
                .getWriterDocument(with: user?.uid ?? "")
            
            if writer.kabinettNumber == 0 {
                return .signInOnly
            } else {
                return .registered
            }
        }
    }
    
    func startLoginUser(
        with userName: String,
        kabinettNumber: Int
    ) async -> Bool {
        guard let currentUser = await authManager.getCurrentUser() else {
            logger.error("There is no user now.")
            return false
        }
        let writer = Writer(
            name: userName,
            kabinettNumber: kabinettNumber,
            profileImage: nil
        )
        
        let result = writerManager.saveWriterDocument(
            with: writer,
            to: currentUser.uid
        )
        
        if result {
            authManager.updateUser(currentUser)
            return true
        } else {
            return false
        }
    }
}
