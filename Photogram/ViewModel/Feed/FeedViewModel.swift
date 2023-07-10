//
//  FeedViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 30.05.2023.
//

import Foundation
import SwiftUI
import Firebase

protocol FeedDataServiceProtocol {
    func fetchPosts(completion: @escaping ([Post]) -> Void)
}

class FeedDataServiceImpl: FeedDataServiceProtocol {
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let posts = documents.compactMap({ try? $0.data(as: Post.self) })
            completion(posts)
        }
    }
}

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    private var dataService: FeedDataServiceProtocol

    init(dataService: FeedDataServiceProtocol = FeedDataServiceImpl()) {
        self.dataService = dataService
        fetchPosts()
    }
    
    func fetchPosts() {
        dataService.fetchPosts { posts in
            self.posts = posts
            print("DEBUG: fetched posts \(self.posts)")
        }
    }
}
