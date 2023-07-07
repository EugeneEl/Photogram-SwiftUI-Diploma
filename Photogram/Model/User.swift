//
//  User.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 19.05.2023.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct User: Identifiable, Decodable {
    let username: String
    let email: String
    let profileImageUrl: String
    let fullname: String
    @DocumentID var id: String?
    var stats: UserStats?
    var bio: String?
    var isFollowed: Bool? = false
    
    var isCurrentUser: Bool {
        return AuthViewModel.shared.userSession?.uid == id
    }
}

struct UserStats: Decodable {
    let posts: Int
    let followers: Int
    let following: Int
}
