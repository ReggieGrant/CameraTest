//
//  FeedView.swift
//  CameraTest
//
//  Created by Reginald Grant on 5/19/26.
//

import SwiftUI
import SwiftData

struct FeedView: View {
    // modelContext is SwiftData's object used to insert, delete, and save data.
    @Environment(\.modelContext) private var modelContext
    
    // @Query automatically loads ProgressEntry items from SwiftData.
    // Sorting by createdAt in reverse order puts the newest entries at the top.
    @Query(sort: \ProgressEntry.createdAt, order: .reverse)
    private var entries: [ProgressEntry] = []
    
    // This helper loads and deletes image files from the app's Documents folder.
    private let imageStore = ImageFileStore()
    
    var body: some View {
        // NavigationStack allows this screen to push detail and add screens.
        NavigationStack{
            List{
                // ForEach creates one row for every saved ProgressEntry.
                ForEach(entries){entry in
                    NavigationLink{
                        EntryDetailView(entry: entry)
                    } label:{
                        HStack{
                            // Try to load the before image. If it is missing, show a placeholder.
                            if let img = imageStore.loadIMG(fileName:entry.beforeImage){
                                Image(uiImage: img)
                                    .resizable()
                                    .frame(width: 54, height: 54)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }else{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 54, height: 54)
                            }
                            
                            VStack{
                                Text(entry.createdAt,style:.date)
                                
                                // Only show the note line when the user typed a note.
                                if entry.note.isEmpty == false {
                                    Text(entry.note)
                                        .lineLimit(1)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                // Swipe-to-delete calls the delete function below.
                .onDelete(perform: delete)
            }
            .navigationTitle("Progress Tracker")
            .toolbar{
                NavigationLink("Add"){
                    AddEntryView()
                }
            }
        }
    }
    
    func delete(_ indexSet: IndexSet){
        // IndexSet contains the row positions that the user deleted.
        for index in indexSet{
            let entry = entries[index]
            
            // Delete the saved image files first so they do not stay on disk.
            imageStore.deleteIMG(fileName: entry.beforeImage)
            imageStore.deleteIMG(fileName: entry.afterImage)
            
            // Delete the SwiftData record from the database.
            modelContext.delete(entry)
        }
        
        // Save the delete operation. try? ignores the error for now.
        try? modelContext.save()
    }
}

#Preview {
    // Previews need their own model container because the real app setup is not running.
    // inMemory means the preview database is temporary and resets when the preview reloads.
    FeedView().modelContainer(for: ProgressEntry.self , inMemory: true)
}
