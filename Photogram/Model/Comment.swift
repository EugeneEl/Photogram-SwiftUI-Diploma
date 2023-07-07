//
//  Comment.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 08.06.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Comment: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let postOwnerUid: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let commentText: String
    let uid: String
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
    }
}

