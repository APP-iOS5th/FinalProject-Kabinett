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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
//         Uncomment these blocks to use Firebase Emulator Suite
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
        
        return true
    }
}
@main
struct KabinettApp: App {
    
    // MARK: - LetterBox Flow
    @StateObject private var letterViewModel: LetterViewModel
    @StateObject private var letterBoxViewModel: LetterBoxViewModel
    @StateObject private var letterBoxDetailViewModel: LetterBoxDetailViewModel
    @StateObject private var calendarViewModel: CalendarViewModel
    
    // MARK: - Profile Flow
    @StateObject private var profileViewModel: ProfileViewModel
    
    // MARK: - SignUp Flow
    @StateObject private var signUpViewModel: SignUpViewModel
    
    // MARK: - Componets Flow
    @StateObject private var imagePickerViewModel: ImagePickerViewModel
    @StateObject private var customTabViewModel: CustomTabViewModel
    
    // MARK: - LetterWrite Flow
    @StateObject private var userSelectionViewModel: UserSelectionViewModel
    @StateObject private var stationerySelectionViewModel: StationerySelectionViewModel
    @StateObject private var fontSelectionViewModel: FontSelectionViewModel
    @StateObject private var writerLetterViewModel: WriteLetterViewModel
    @StateObject private var envelopStampSelectionViewModel: EnvelopeStampSelectionViewModel
    @StateObject private var letterWritePreviewViewModel: LetterWritePreviewViewModel
    
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
        /// This object performs 3 use cases.
        /// LetterWriteUseCase, ComponentsUseCase, LetterBoxUseCase
        let firebaseFirestoreManager = FirebaseFirestoreManager(
            authManager: authManager,
            writerManager: writerManager
        )
        /// This object performs 2 use cases.
        /// LetterWriteLoadStuffUseCase, ComponentsLoadStuffUseCase
        let firebaseStorageManager = FirebaseStorageManager()
        
        // MARK: - LetterBox ViewModels
        _letterViewModel = .init(
            wrappedValue: LetterViewModel(
                letterBoxUseCase: firebaseFirestoreManager
            )
        )
        _letterBoxViewModel = .init(
            wrappedValue: LetterBoxViewModel(
                letterBoxUseCase: firebaseFirestoreManager
            )
        )
        _letterBoxDetailViewModel = .init(
            wrappedValue: LetterBoxDetailViewModel(
                letterBoxUseCase: firebaseFirestoreManager
            )
        )
        _calendarViewModel = .init(
            wrappedValue: CalendarViewModel()
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
                componentsUseCase: firebaseFirestoreManager,
                componentsLoadStuffUseCase: firebaseStorageManager,
                firebaseFirestoreManager: firebaseFirestoreManager
            )
        )
        _customTabViewModel = .init(
            wrappedValue: CustomTabViewModel()
        )
        
        // MARK: - LetterWrite ViewModels
        _userSelectionViewModel = .init(
            wrappedValue: UserSelectionViewModel(
                useCase: firebaseFirestoreManager
            )
        )
        _stationerySelectionViewModel = .init(
            wrappedValue: StationerySelectionViewModel(
                useCase: firebaseStorageManager
            )
        )
        _fontSelectionViewModel = .init(
            wrappedValue: FontSelectionViewModel()
        )
        _writerLetterViewModel = .init(
            wrappedValue: WriteLetterViewModel()
        )
        _envelopStampSelectionViewModel = .init(
            wrappedValue: EnvelopeStampSelectionViewModel(
                useCase: firebaseStorageManager
            )
        )
        _letterWritePreviewViewModel = .init(
            wrappedValue: LetterWritePreviewViewModel(
                useCase: firebaseFirestoreManager
            )
        )
    }
    
    var body: some Scene {
        WindowGroup {
            CustomTabView()
                .environmentObject(letterViewModel)
                .environmentObject(letterBoxViewModel)
                .environmentObject(letterBoxDetailViewModel)
                .environmentObject(calendarViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(signUpViewModel)
                .environmentObject(imagePickerViewModel)
                .environmentObject(customTabViewModel)
                .environmentObject(userSelectionViewModel)
                .environmentObject(stationerySelectionViewModel)
                .environmentObject(fontSelectionViewModel)
                .environmentObject(writerLetterViewModel)
                .environmentObject(writerLetterViewModel)
                .environmentObject(envelopStampSelectionViewModel)
                .environmentObject(letterWritePreviewViewModel)
        }
    }
}
