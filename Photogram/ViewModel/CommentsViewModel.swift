//
//  CommentsViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 08.06.2023.
//

import Foundation
import Firebase

class CommentsViewModel: ObservableObject {
    
    private let post: Post
    @Published var comments = [Comment]()
    
    init(post: Post) {
        self.post = post
        self.fetchComments()
    }
    
    func uploadComment(commentText: String) {
        guard let user = AuthViewModel.shared.currentUser else {return}
        guard let postId = post.id else {return}
        let data = ["username": user.username,
                    "profileImageUrl": user.profileImageUrl,
                    "uid": user.id,
                    "timestamp": Timestamp(date: Date()),
                    "postOwnerUid": post.ownerUid,
                    "commentText": commentText] as [String : Any]
        
        COLLECTION_POSTS.document(postId).collection("comments").addDocument(data: data) { error in
            if let error = error {
                print("DEBUG: uploading comment error: \(error.localizedDescription)")
            }
            
            NotificationsViewModel.uploadNotification(toUid: self.post.ownerUid, type: .comment, post: self.post)
            
            print("DEBUG: Finished uploading comment for post id: \(postId)")
        }
    }
    
    func fetchComments() {
        guard let id = post.id else {return}
        
        let query = COLLECTION_POSTS.document(id).collection("comments").order(by: "timestamp", descending: true)
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print("DEBUG: fetching comments error: \(error.localizedDescription)")
                return
            }
            
            guard let addedDocs = snapshot?.documentChanges.filter({ $0.type == .added }) else {return}
            
            let newComments = addedDocs.compactMap({ try? $0.document.data(as: Comment.self) })
            
            self.comments.append(contentsOf: newComments)
        }
    }
}
