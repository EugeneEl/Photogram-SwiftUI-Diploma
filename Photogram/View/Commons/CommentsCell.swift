//
//  CommentsCell.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 08.06.2023.
//

import SwiftUI
import Kingfisher

struct CommentsCell: View {
    
    private let comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    var body: some View {
        HStack {
            KFImage(URL(string: comment.profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
            Text(comment.username)
                .font(.system(size: 14, weight: .semibold))
            +
            Text(" \(comment.commentText)").font(.system(size: 14))
            Spacer()
            Text(" \(comment.timestampString)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(.trailing)
        }
        .padding(.horizontal)
    }
}

