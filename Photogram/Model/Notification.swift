//
//  Notification.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 14.06.2023.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

struct Notification: Identifiable, Decodable {
    @DocumentID var id: String?
    let postId: String?
//    let postImageUrl: String?
    let username: String
    let timestamp: Timestamp
    let profileImageUrl: String
    let type: NotificationType
    let uid: String
//    let commentText: String?
//    let userIsFollowed: Bool?
    
    var post: Post?
    var user: User?
    var isFollowed: Bool? = false
}

enum NotificationType: Int, Decodable {
    case like
    case comment
    case follow
    
    var notificationMessage: String {
        switch self {
        case .like: return " liked one of your posts."
        case .comment: return " commented on one of your posts."
        case .follow: return " started following you."
        }
    }
}
