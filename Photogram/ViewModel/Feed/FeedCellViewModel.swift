//
//  FeedCellViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 06.06.2023.
//

import Foundation
import SwiftUI

protocol FeedCellServiceProtocol {
    func likePost(post: Post, completion: @escaping (Result<Void, Error>) -> Void)
    func unlikePost(post: Post, completion: @escaping (Result<Void, Error>) -> Void)
    func checkIfUserLikedPost(post: Post, completion: @escaping (Result<Bool, Error>) -> Void)
}

class FeedCellServiceImpl: FeedCellServiceProtocol {
    func likePost(post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let postId = post.id else { return }
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        
        COLLECTION_POSTS.document(postId).collection("post-likes")
            .document(postId).setData([String : Any]()) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                COLLECTION_USERS.document(uid).collection("user-likes").document(postId).setData([String : Any]()) { [self] (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    COLLECTION_POSTS.document(postId).updateData(["likes": post.likes + 1])
                    
                    NotificationsViewModel.uploadNotification(toUid: post.ownerUid, type: .like, post: post)
                    
                    completion(.success(()))
                }
            }
    }
    
    func unlikePost(post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        guard post.likes > 0 else {return}
        guard let postId = post.id else { return }
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        
        COLLECTION_POSTS.document(postId).collection("post-likes")
            .document(postId).delete { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                COLLECTION_USERS.document(uid).collection("user-likes").document(postId).delete { [self] (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    COLLECTION_POSTS.document(postId).updateData(["likes": post.likes - 1])
                    completion(.success(()))
                }
            }
    }
    
    func checkIfUserLikedPost(post: Post, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let postId = post.id else { return }
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(postId).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let didLike = snapshot?.exists else { return }
                completion(.success(didLike))
            }
        }
    }
}


class FeedCellViewModel: ObservableObject {
    @Published var post: Post
    private var cellService: FeedCellServiceProtocol

    var likeString: String {
        let label = post.likes == 1 ? "like" : "likes"
        return "\(post.likes) \(label)"
    }

    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: post.timestamp.dateValue(), to: Date()) ?? ""
    }

    init(post: Post, cellService: FeedCellServiceProtocol = FeedCellServiceImpl()) {
        self.post = post
        self.cellService = cellService
        checkIfUserLikedPost()
    }

    func like() {
        cellService.likePost(post: post) { [weak self] result in
            switch result {
            case .success():
                self?.post.didLike = true
                self?.post.likes += 1
            case .failure(let error):
                print("DEBUG: Error liking post \(error.localizedDescription)")
            }
        }
    }

    func unlike() {
        cellService.unlikePost(post: post) { [weak self] result in
            switch result {
            case .success():
                self?.post.didLike = false
                self?.post.likes -= 1
            case .failure(let error):
                print("DEBUG: Error unliking post \(error.localizedDescription)")
            }
        }
    }

    func checkIfUserLikedPost() {
        cellService.checkIfUserLikedPost(post: post) { [weak self] result in
            switch result {
            case .success(let didLike):
                self?.post.didLike = didLike
            case .failure(let error):
                print("DEBUG: Error checking if user liked post \(error.localizedDescription)")
            }
        }
    }
}
