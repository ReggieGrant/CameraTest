//
//  ContentView.swift
//  CameraTest
//
//  Created by Reginald Grant on 5/19/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        // This keeps the app's root screen simple: show the feed first.
        FeedView()
    }
}

#Preview {
    ContentView()
        // Previews do not automatically get the app's database container.
        // inMemory keeps preview data temporary so it does not affect the real app.
        .modelContainer(for: ProgressEntry.self, inMemory: true)
}
