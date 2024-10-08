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
    @StateObject private var contentWriteViewModel: ContentWriteViewModel
    @StateObject private var envelopStampSelectionViewModel: EnvelopeStampSelectionViewModel
    @StateObject private var previewLetterViewModel: PreviewLetterViewModel
    
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
        let letterManager = FirestoreLetterManager(storageManager: letterStorageManager)
        
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
        let letterboxUseCase = DefaultLetterBoxUseCase(
            letterManager: letterManager,
            authManager: authManager
        )
        
        // MARK: - LetterBox ViewModels
        _letterViewModel = .init(
            wrappedValue: LetterViewModel(
                letterBoxUseCase: letterboxUseCase
            )
        )
        _letterBoxViewModel = .init(
            wrappedValue: LetterBoxViewModel(
                letterBoxUseCase: letterboxUseCase
            )
        )
        _letterBoxDetailViewModel = .init(
            wrappedValue: LetterBoxDetailViewModel(
                letterBoxUseCase: letterboxUseCase
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
                componentsUseCase: photoLetterUseCase
            )
        )
        _customTabViewModel = .init(
            wrappedValue: CustomTabViewModel()
        )
        
        // MARK: - LetterWrite ViewModels
        _userSelectionViewModel = .init(
            wrappedValue: UserSelectionViewModel(
                useCase: normalLetterUseCase
            )
        )
        _stationerySelectionViewModel = .init(
            wrappedValue: StationerySelectionViewModel(
                useCase: normalLetterUseCase
            )
        )
        _fontSelectionViewModel = .init(
            wrappedValue: FontSelectionViewModel()
        )
        _contentWriteViewModel = .init(
            wrappedValue: ContentWriteViewModel()
        )
        _envelopStampSelectionViewModel = .init(
            wrappedValue: EnvelopeStampSelectionViewModel(
                useCase: normalLetterUseCase
            )
        )
        _previewLetterViewModel = .init(
            wrappedValue: PreviewLetterViewModel(
                useCase: normalLetterUseCase
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
                .environmentObject(contentWriteViewModel)
                .environmentObject(envelopStampSelectionViewModel)
                .environmentObject(previewLetterViewModel)
        }
    }
}
