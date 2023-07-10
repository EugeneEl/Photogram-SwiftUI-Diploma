//
//  PostGridViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 31.05.2023.
//

import Foundation

enum PostGridConfiguration {
    case explore
    case profile(String)
}

class PostGridViewModel: ObservableObject {
    @Published var posts = [Post]()
    let config: PostGridConfiguration
    
    init(config: PostGridConfiguration) {
        self.config = config
        fetchPosts(for: config)
    }
    
    func fetchPosts(for config: PostGridConfiguration) {
        switch config {
        case .explore:
            fetchExplorePagePosts()
        case .profile(let uid):
            fetchUserPosts(for: uid)
        }
    }
    
    func fetchExplorePagePosts() {
        COLLECTION_POSTS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            self.posts = documents.compactMap({ try? $0.data(as: Post.self) })
            print("DEBUG: self.posts \(self.posts)")
        }
    }
    
    func fetchUserPosts(for uid: String) {
        COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            self.posts = documents.compactMap({ try? $0.data(as: Post.self) }).sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            print("DEBUG: self.posts \(self.posts)")
        }
    }
}
