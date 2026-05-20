//
//  ProgressEntry.swift
//  CameraTest
//
//  Created by Reginald Grant on 5/19/26.
//

import Foundation
import SwiftData

// @Model tells SwiftData that this class should be saved in the app's database.
// Each ProgressEntry represents one before/after progress record.
@Model
class ProgressEntry{
    // UUID gives every entry a unique id so SwiftUI can tell entries apart.
    var id: UUID
    
    // Date is saved so the feed can show when the entry was created.
    var createdAt: Date
    var note: String
    
    // The images themselves are saved as files. SwiftData stores the file names here.
    var beforeImage:String
    var afterImage:String
    
    // The initializer fills in all the stored values when a new entry is created.
    init(id: UUID = UUID(), createdAt: Date = Date(), note: String, beforeImage: String, afterImage: String) {
        self.id = id
        self.createdAt = createdAt
        self.note = note
        self.beforeImage = beforeImage
        self.afterImage = afterImage
    }
}
