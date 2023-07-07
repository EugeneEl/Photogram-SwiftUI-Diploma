//
//  NotificationCellViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 19.06.2023.
//

import Foundation
import SwiftUI

class NotificationCellViewModel: ObservableObject {
    @Published var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
        checkIfUserIsFollowed()
        fetchNotificationPost()
        fetchNotificationUser()
    }
    
    var timestampString: String {
        let timestamp = notification.timestamp
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
    }
    
    func follow() {
        print("DEBUG: Follow user here..")
        UserService.follow(uid: notification.uid) { _ in
            
            NotificationsViewModel.uploadNotification(toUid: self.notification.uid, type: .follow)
            
            self.notification.isFollowed = true
        }
    }
    
    func unfollow() {
        print("DEBUG: Unfollow user here..")
        UserService.unfollow(uid: notification.uid) { _ in
            self.notification.isFollowed = false
        }
    }
    
    func checkIfUserIsFollowed() {
        guard notification.type == .follow else {return}
        UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
            self.notification.isFollowed = isFollowed
        }
    }
    
    func fetchNotificationPost() {
        print("notification.postId: \(notification.postId)")
        guard let postId = notification.postId else {return}
        COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
            self.notification.post = try? snapshot?.data(as: Post.self)
            print("self.notification.post: \(self.notification.post)")
        }
    }
    
    func fetchNotificationUser() {
        COLLECTION_USERS.document(notification.uid).getDocument { snapshot, _ in
            self.notification.user = try? snapshot?.data(as: User.self)
            print("DEBUG: \(self.notification.user?.username)")
        }
    }
}
