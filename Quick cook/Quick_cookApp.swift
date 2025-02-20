//
//  Quick_cookApp.swift
//  Quick cook
//
//  Created by Harry Fatukasi on 2025-02-17.
//

import SwiftUI
import PhotosUI

@main
struct QuickCookApp: App {
    @AppStorage("shouldShowSplash") var shouldShowSplash = true
    
    var body: some Scene {
        WindowGroup {
            if shouldShowSplash {
                SplashView()
            } else {
                ContentView()
            }
        }
    }
}
