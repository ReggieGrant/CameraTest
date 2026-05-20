//
//  EntryDetailView.swift
//  CameraTest
//
//  Created by Reginald Grant on 5/19/26.
//

import SwiftUI

struct EntryDetailView: View {

    // This view receives the entry that was tapped in FeedView.
    let entry: ProgressEntry
    
    // Used to turn saved image file names back into UIImage values.
    private let imageStore = ImageFileStore()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                Text(entry.createdAt, style: .date)
                    .font(.title2)
                    .bold()

                VStack(alignment: .leading, spacing: 12) {

                    Text("Before").font(.headline)
                    photoBox(fileName: entry.beforeImage)

                    Text("After").font(.headline)
                    photoBox(fileName: entry.afterImage)
                }

                // Do not show an empty note section if the user did not type one.
                if entry.note.isEmpty == false {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note").font(.headline)

                        Text(entry.note)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.secondary.opacity(0.4))
                            )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func photoBox(fileName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .frame(height: 260)

            // If the file exists, show the photo. Otherwise, show fallback text.
            if let img = imageStore.loadIMG(fileName: fileName) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text("Image not found")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
