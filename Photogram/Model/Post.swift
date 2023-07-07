//
//  Post.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 30.05.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Post: Identifiable, Decodable {
    @DocumentID var id: String?
    let ownerUid: String
    let ownerUsername: String
    let caption: String
    var likes: Int
    let imageURL: String
    let timestamp: Timestamp
    var didLike: Bool? = false
    let ownerImageUrl: String
}

