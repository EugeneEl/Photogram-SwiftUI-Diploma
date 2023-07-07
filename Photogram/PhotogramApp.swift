//
//  PhotogramApp.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 02.05.2023.
//

import SwiftUI
import Firebase

@main
struct PhotogramApp: App {
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel.shared)
        }
    }
}
