//
//  UploadPostViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 29.05.2023.
//

import Foundation
import SwiftUI
import Firebase

class UploadPostViewModel: ObservableObject {
    func uploadPost(caption: String, image: UIImage, completion: @escaping FirestoreCompletion) {
        print("DEBUG: uploading post")
        guard let user = AuthViewModel.shared.currentUser else { return }
        
        ImageUploader.uploadImage(image: image, type: .post) { imageURL in
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageURL": imageURL,
                        "ownerUid": user.id ?? "",
                        "ownerImageUrl": user.profileImageUrl,
                        "ownerUsername": user.username] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data) { error in
                print("DEBUG: Successfully uploaded post")
                completion(error)
            }
        }
    }
}

