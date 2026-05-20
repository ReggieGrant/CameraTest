//
//  AddEntryView.swift
//  CameraTest
//
//  Created by Reginald Grant on 5/19/26.
//

import SwiftUI
import SwiftData
import PhotosUI
import UIKit

struct AddEntryView:View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var vm = AddEntryViewModel()
    
    @State private var beforePickerItem: PhotosPickerItem? = nil
    @State private var afterPickerItem: PhotosPickerItem? = nil
    
    @State private var showBeforeCamera: Bool = false
    @State private var showAfterCamera: Bool = false
    
    
    private var cameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing:16){
                Text("New Progress Entry")
                    .font(.title2)
                
                // BEFORE PICKER
                VStack{
                    Text("Before").font(.headline)
                    photoBox(image: vm.beforeImage)
                    
                    HStack{
                        PhotosPicker("Choose photo", selection: $beforePickerItem, matching: .images)
                        Button("Take a photo"){
                            showBeforeCamera = true
                        }.disabled(cameraAvailable == false)
                    }
                    
                    if cameraAvailable == false {
                        Text("Camera not available (use a real device).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                }
                VStack{
                    Text("After").font(.headline)
                    photoBox(image: vm.afterImage)
                    
                    HStack{
                        PhotosPicker("Choose photo", selection: $afterPickerItem, matching: .images)
                        Button("Take a photo"){
                            showAfterCamera = true
                        }.disabled(cameraAvailable == false)
                    }
                    
                    if cameraAvailable == false {
                        Text("Camera not available (use a real device).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                }
                
                TextField("Note", text: $vm.note, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
                
                Button("Save") {
                    if vm.save(modelContext: modelContext) {
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.canSave() == false)
            }
            .padding()
        }
        .onChange(of: beforePickerItem) { _, newValue in
            vm.setBeforePickerItem(newValue)
        }
        .onChange(of: afterPickerItem) { _, newValue in
            vm.setAfterPickerItem(newValue)
        }
        .sheet(isPresented: $showBeforeCamera) {
            CameraPicker { image in
                vm.beforeImage = image
            }
        }
        .sheet(isPresented: $showAfterCamera) {
            CameraPicker { image in
                vm.afterImage = image
            }
        }
        .alert("Error", isPresented: $vm.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.errorMessage)
        }
    }
    
    private func photoBox(image: UIImage?) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .frame(height: 180)
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text("No photo selected")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
