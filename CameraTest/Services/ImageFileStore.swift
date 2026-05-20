//
//  ImageFileStore.swift
//  CameraTest
//
//  Created by Reginald Grant on 5/19/26.
//

import Foundation
import UIKit

// This class handles saving, loading, and deleting image files.
// SwiftData stores text and dates well, but large images are better saved as files.
class ImageFileStore {
    
    private let folderName: String = "CameraDemoStorage"
    
    enum Kind {
        case before
        case after
    }

    // Creates a file name that marks whether the image is before or after.
    // Example: 10BC1LOP_before.jpg or 10BC1LOP_after.jpg
    func makeFileName(id:UUID, kind: Kind) -> String{
        if kind == .before {
            return id.uuidString + "_before.jpg"
        } else{
            return id.uuidString + "_after.jpg"
        }
    }
    
    // Converts a UIImage into JPEG data and writes it to disk.
    func saveIMG(_ image:UIImage,fileName:String) throws {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            throw NSError(
                domain: "CameraDemoStorage", code: 1, userInfo: [NSLocalizedDescriptionKey:"Could not convert image into DATA"]
            )
        }
        
        let url = fileURL(fileName: fileName)
        try data.write(to: url, options: .atomic)
    }
    
    // Reads JPEG data from disk and turns it back into a UIImage.
    func loadIMG(fileName:String)-> UIImage?{
        let url = fileURL(fileName: fileName)
        
        // If the file is missing, return nil so the UI can show a placeholder.
        if FileManager.default.fileExists(atPath: url.path()) == false {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {return nil}
        return UIImage(data: data)
    }
    
    func deleteIMG(fileName:String){
        let url = fileURL(fileName: fileName)
        
        // Nothing needs to happen if the file is already gone.
        if FileManager.default.fileExists(atPath: url.path()) == false {
            return
        }
        
        try? FileManager.default.removeItem(at: url)
    }
    
    func createFolderIfNeeded(){
        let url = folderURL()
        
        if FileManager.default.fileExists(atPath:url.path()){
            return
        }
        
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }
    
    // The app's Documents directory is a place where this app can store user files.
    func docURL()->URL{
        FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
    }
    
    // This creates a folder inside Documents just for this app's saved images.
    func folderURL ()-> URL {
        docURL().appendingPathComponent(folderName)
    }
    
    func fileURL(fileName:String) -> URL {
        createFolderIfNeeded()
        return folderURL().appendingPathComponent(fileName)
    }
}
