//
//  ImagePicker.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 08.05.2023.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
        @Binding var image: UIImage?
        @Environment(\.presentationMode) var mode
        
        func makeUIViewController(context: Context) -> some UIViewController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(self)
        }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {return}
            self.parent.image = image
            self.parent.mode.wrappedValue.dismiss()
        }
    }
}
