//
//  KabinettApp.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/8/24.
//

import SwiftUI
import FirebaseCore
//import FirebaseAuth
//import FirebaseStorage
//import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Uncomment these blocks to use Firebase Emulator Suite
//        #if DEBUG
//        // Firebase Authenticate Emulator
//        Auth.auth().useEmulator(withHost:"localhost", port:9099)
//        
//        // Firebase Storage Emulator
//        Storage.storage().useEmulator(withHost: "localhost", port: 9199)
//        
//        // Firebaes Firestore Emulator
//        let settings = Firestore.firestore().settings
//        settings.host = "localhost:8080"
//        settings.isSSLEnabled = false
//        Firestore.firestore().settings = settings
//        #endif
        
        return true
    }
}


@main
struct KabinettApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var imagePickerViewModel = ImagePickerViewModel(
        componentsUseCase: MockComponentsUseCase(),
        componentsLoadStuffUseCase: MockComponentsLoadStuffUseCase()
    )
    @StateObject var customTabViewModel = CustomTabViewModel()
    var body: some Scene {
        WindowGroup {
            CustomTabView()
            .environmentObject(imagePickerViewModel)
            .environmentObject(customTabViewModel)
        }
    }
}
