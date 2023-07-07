//
//  NotificationsViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 14.06.2023.
//

import Foundation
import SwiftUI
import Firebase

class NotificationsViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    
    init() {
        fetchNotifications()
    }
    
    func fetchNotifications() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }

        let query = COLLECTION_NOTIFICATIONS.document(uid).collection("customer-notifications")
            .order(by: "timestamp", descending: true)

        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }

            self.notifications = documents.compactMap({ try? $0.data(as: Notification.self) })
            print("DEBUG: fetched notifications: \(self.notifications)")
        }
    }
    
    static func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let user = AuthViewModel.shared.currentUser else {return}
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        // Check we don't send notification to ourselves.
        guard uid != currentUid else { return }
        
        var data: [String: Any] = [
            "timestamp": Timestamp(date: Date()),
            "username": user.username,
            "uid": currentUid,
            "type": type.rawValue,
            "id": UUID().uuidString,
            "profileImageUrl": user.profileImageUrl
        ]
        
        if let post = post, let id = post.id {
            data["postId"] = id
        }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("customer-notifications").addDocument(data: data)
    }
}

