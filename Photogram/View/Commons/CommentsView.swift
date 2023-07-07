//
//  CommentsView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 08.06.2023.
//

import SwiftUI

struct CommentsView: View {
    @State var commentText = ""
    @ObservedObject var viewModel: CommentsViewModel
    
    init(post: Post) {
        self.viewModel = CommentsViewModel(post: post)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.comments) { comment in
                        CommentsCell(comment: comment)
                            .padding()
                    }
                }
            }
        }.padding(.top)
        
        CustomInputView(inputText: $commentText, action: uploadComment)
    }
    
    func uploadComment() {
        viewModel.uploadComment(commentText: commentText)
        commentText = ""
    }
}
