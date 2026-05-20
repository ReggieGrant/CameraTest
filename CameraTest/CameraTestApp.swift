//
//  CameraTestApp.swift
//  CameraTest
//
//  Created by Reginald Grant on 5/19/26.
//

import SwiftUI
import SwiftData

// @main marks this as the starting point of the app.
@main
struct CameraTestApp: App {
    var body: some Scene {
        WindowGroup {
            // ContentView is the first screen shown when the app opens.
            ContentView()
        }
        // This creates the SwiftData database container for ProgressEntry.
        // Any child view can read or save ProgressEntry objects through modelContext.
        .modelContainer(for: ProgressEntry.self)
    }
}
