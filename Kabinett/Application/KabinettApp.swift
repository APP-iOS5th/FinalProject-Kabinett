//
//  KabinettApp.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/8/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

@main
struct KabinettApp: App {
    // MARK: - Profile Flow
    @StateObject private var profileViewModel: ProfileViewModel
    
    // MARK: - SignUp Flow
    @StateObject private var signUpViewModel: SignUpViewModel
    
    // MARK: - Componets Flow
    @StateObject private var imagePickerViewModel: ImagePickerViewModel
    @StateObject private var customTabViewModel: CustomTabViewModel
    
    init() {
        // Init Firebase App
        FirebaseApp.configure()
        
        #if DEBUG
        // Firebase Authenticate Emulator
        Auth.auth().useEmulator(withHost:"localhost", port:9099)
        
        // Firebase Storage Emulator
        Storage.storage().useEmulator(withHost: "localhost", port: 9199)
        
        // Firebaes Firestore Emulator
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        #endif
        
        // MARK: - Service Dependencies
        let writerManager = FirestoreWriterManager()
        let writerStorageManager = FirestorageWriterManager()
        let authManager = AuthManager(writerManager: writerManager)
        let letterStorageManager = FirestorageLetterManager()
        let letterManager = FirestoreLetterManager()
        
        // MARK: - UseCase Dependencies
        let profileUseCase = DefaultProfileUseCase(
            authManager: authManager,
            writerManager: writerManager,
            writerStorageManager: writerStorageManager
        )
        let signUpUseCase = DefaultSignUpUseCase(
            authManager: authManager,
            writerManager: writerManager
        )
        let normalLetterUseCase = DefaultWriteLetterUseCase(
            authManager: authManager,
            writerManager: writerManager,
            letterManager: letterManager,
            letterStorageManager: letterStorageManager
        )
        let photoLetterUseCase = DefaultImportLetterUseCase(
            authManager: authManager,
            writerManager: writerManager,
            letterManager: letterManager,
            letterStorageManager: letterStorageManager
        )
        
        // MARK: - Profile ViewModel
        _profileViewModel = .init(
            wrappedValue: ProfileViewModel(
                profileUseCase: profileUseCase
            )
        )
        
        // MARK: - SignUp ViewModel
        _signUpViewModel = .init(
            wrappedValue: SignUpViewModel(
                signUpUseCase: signUpUseCase
            )
        )
        
        // MARK: - Componets ViewModels
        _imagePickerViewModel = .init(
            wrappedValue: ImagePickerViewModel(
                componentsUseCase: photoLetterUseCase
            )
        )
        _customTabViewModel = .init(
            wrappedValue: CustomTabViewModel()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            CustomTabView()
                .onAppear {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithTransparentBackground()
                    
                    let backItemAppearance = UIBarButtonItemAppearance()
                    backItemAppearance.normal.titleTextAttributes = [
                        .foregroundColor : UIColor.clear
                    ]
                    appearance.backButtonAppearance = backItemAppearance
                    
                    let image = UIImage(systemName: "chevron.backward")?
                        .withTintColor(
                            .primary900,
                            renderingMode: .alwaysOriginal
                        )
                        .withAlignmentRectInsets(
                            UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 0)
                        )
                    appearance.setBackIndicatorImage(image, transitionMaskImage: image)

                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                    UINavigationBar.appearance().compactAppearance = appearance
                    UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
                }
            
        }
    }
    
    // MARK: - Dependency Injection Container Setup
    // MARK: Register Services
    private static func registerServices() {
        // MARK: Register Firestorage Services
        DIContainer.shared.register {
            Module(FirestorageWriterManagerKey.self) {
                FirestorageWriterManager()
            }
            Module(FirestorageLetterManagerKey.self) {
                FirestorageLetterManager()
            }
        }
        
        // MARK: Register Firestore Services
        DIContainer.shared.register {
            Module(FirestoreWriterManagerKey.self) {
                FirestoreWriterManager()
            }
            Module(FirestoreLetterManagerKey.self) {
                @Injected(FirestorageLetterManagerKey.self)
                var firestorageLetterManager: FirestorageLetterManager
                
                return FirestoreLetterManager(storageManager: firestorageLetterManager)
            }
        }
        
        // MARK: Register Firestore Authenticate Service
        DIContainer.shared.register {
            Module(AuthManagerKey.self) {
                @Injected(FirestoreWriterManagerKey.self)
                var firestoreWriterManager: FirestoreWriterManager
                
                return AuthManager(writerManager: firestoreWriterManager)
            }
        }
    }
    
    // MARK: - Register UseCases
    private static func registerUseCases() {
        @Injected(AuthManagerKey.self) var authManager: AuthManager
        
        @Injected(FirestoreWriterManagerKey.self)
        var firestoreWriterManager: FirestoreWriterManager
        
        @Injected(FirestoreLetterManagerKey.self)
        var firestoreLetterManager: FirestoreLetterManager
        
        @Injected(FirestorageWriterManagerKey.self)
        var firestorageWriterManager: FirestorageWriterManager
        
        @Injected(FirestorageLetterManagerKey.self)
        var firestorageLetterManager: FirestorageLetterManager
        
        DIContainer.shared.register {
            Module(SignUpUseCaseKey.self) {
                DefaultSignUpUseCase(
                    authManager: authManager,
                    writerManager: firestoreWriterManager
                )
            }
            Module(ProfileUseCaseKey.self) {
                DefaultProfileUseCase(
                    authManager: authManager,
                    writerManager: firestoreWriterManager,
                    writerStorageManager: firestorageWriterManager
                )
            }
            Module(WriteLetterUseCaseKey.self) {
                DefaultWriteLetterUseCase(
                    authManager: authManager,
                    writerManager: firestoreWriterManager,
                    letterManager: firestoreLetterManager,
                    letterStorageManager: firestorageLetterManager
                )
            }
            Module(LetterBoxUseCaseKey.self) {
                DefaultLetterBoxUseCase(
                    letterManager: firestoreLetterManager,
                    authManager: authManager
                )
            }
            Module(ImportLetterUseCaseKey.self) {
                DefaultImportLetterUseCase(
                    authManager: authManager,
                    writerManager: firestoreWriterManager,
                    letterManager: firestoreLetterManager,
                    letterStorageManager: firestorageLetterManager
                )
            }
        }
    }
}
