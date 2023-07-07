//
//  ProfileViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 23.05.2023.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    func follow() {
        print("DEBUG: Follow user here..")
        guard let uid = user.id else {return}
        UserService.follow(uid: uid) { _ in
            
            NotificationsViewModel.uploadNotification(toUid: uid, type: .follow)
            
            print("DEBUG: Followed \(self.user.username)")
            self.user.isFollowed = true
        }
    }
    
    func unfollow() {
        print("DEBUG: Unfollow user here..")
        guard let uid = user.id else {return}
        
        UserService.unfollow(uid: uid) { _ in
            print("DEBUG: Unfollowed \(self.user.username)")
            self.user.isFollowed = false
        }
    }
    
    func checkIfUserIsFollowed() {
        guard let uid = user.id else {return}
        guard user.isCurrentUser else {return}
        UserService.checkIfUserIsFollowed(uid: uid) { isFollowed in
            self.user.isFollowed = isFollowed
        }
        print("DEBUG: Check if user is followed here..")
    }
    
    func fetchUserStats() {
        guard let uid = user.id else {return}
        
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            guard let followers = snapshot?.documents.count else {return}
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, _ in
                guard let following = snapshot?.documents.count else {return}
                
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, _ in
                    guard let posts = snapshot?.documents.count else {return}
                    
                    self.user.stats = UserStats(posts: posts, followers: followers, following: following)
                    print("DEBUG: user stats \(self.user.stats)")
                }
            }
        }
    }
}
