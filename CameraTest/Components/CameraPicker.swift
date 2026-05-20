//
//  CameraPicker.swift
//  CameraTest
//
//  Created by Reginald Grant on 5/19/26.
//

import SwiftUI
import UIKit

// UIImagePickerController is a UIKit camera screen.
// UIViewControllerRepresentable lets SwiftUI display that UIKit screen.
struct CameraPicker: UIViewControllerRepresentable{
   
    // This closure sends the selected camera image back to AddEntryView.
    let onImagePicked: (UIImage)-> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        
        return picker
    }
    
    // This is required by UIViewControllerRepresentable.
    // It is empty because the camera picker does not need live updates after it appears.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator{
        Coordinator(onImagePicked: onImagePicked, dismiss: dismiss)
    }
    
    // Coordinator receives UIKit delegate callbacks and passes them into SwiftUI.
    class Coordinator: NSObject,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
        
        let onImagePicked: (UIImage) -> Void
        let dismiss: DismissAction
        
        init(onImagePicked: @escaping (UIImage) -> Void, dismiss: DismissAction) {
            self.onImagePicked = onImagePicked
            self.dismiss = dismiss
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // UIKit gives the picked image in the info dictionary.
            if let image = info[.originalImage] as? UIImage {
                onImagePicked(image)
            }
            dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss()
        }
    }
}
