//
//  AddEntryViewModel.swift
//  CameraTest
//
//  Created by Reginald Grant on 5/19/26.
//

import Foundation
import SwiftData
import PhotosUI
import UIKit
import Combine
import _PhotosUI_SwiftUI

// @MainActor keeps UI-related changes on the main thread.
// ObservableObject lets SwiftUI watch this class for changes.
@MainActor
class AddEntryViewModel: ObservableObject{
    
    // @Published tells SwiftUI to refresh views when these values change.
    @Published var note: String = ""
    @Published var beforeImage: UIImage? = nil
    @Published var afterImage: UIImage? = nil

    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // This helper saves and loads image files.
    let imageStore = ImageFileStore()
    
    func setBeforePickerItem(_ item: PhotosPickerItem?){
        loadUIImage(from: item){ [weak self] image in
            self?.beforeImage = image
        }
    }
    
    func setAfterPickerItem(_ item: PhotosPickerItem?){
        loadUIImage(from: item){ [weak self] image in
            self?.afterImage = image
        }
    }
            
    // Takes a photo picker item and converts its data into a UIImage.
    func loadUIImage(from item:PhotosPickerItem?, completion:@escaping (UIImage?)->Void){
        guard let item else{
            completion(nil)
            return
        }
        
        // Loading picker data is async because it can take time to read the image.
        Task{
            if let data = try? await item.loadTransferable(type: Data.self){
                let image = UIImage(data: data)
                completion(image)
            }else{
                completion(nil)
            }
        }
    }
    
    // The save button should only work after both photos are selected.
    func canSave()->Bool{
        return beforeImage != nil && afterImage != nil
    }
    
    func save(modelContext: ModelContext) ->Bool{
        // guard exits early if either image is missing.
        guard let beforeImage, let afterImage else {
            errorMessage = "select both photos"
            showError = true
            return false
        }
        
        let id = UUID()
        
        // Make stable file names so the database can point to the image files.
        let beforeName = imageStore.makeFileName(id: id, kind: .before)
        let afterName = imageStore.makeFileName(id: id, kind: .after)

        do{
            try imageStore.saveIMG(beforeImage,fileName: beforeName)
            try imageStore.saveIMG(afterImage, fileName: afterName)
        } catch{
            errorMessage = "Could not save image"
            showError = true
            return false
        }
        
        // Create the SwiftData object that will appear in FeedView.
        let entry = ProgressEntry(
            id:id,
            createdAt: Date(),
            note: note,
            beforeImage: beforeName,
            afterImage: afterName
        )
        
        modelContext.insert(entry)
        
        do{
            try modelContext.save()
        }catch{
            errorMessage = "Could not save entry"
            showError = true
            return false
        }
        return true
    }
}
