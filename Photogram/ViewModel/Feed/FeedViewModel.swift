//
//  FeedViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 30.05.2023.
//

import Foundation
import SwiftUI
import Firebase

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            self.posts = documents.compactMap({try? $0.data(as: Post.self)})
            print("DEBUG: fetched posts \(self.posts)")
        }
    }
}

