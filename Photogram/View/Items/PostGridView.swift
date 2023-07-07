//
//  PostGridView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 03.05.2023.
//

import SwiftUI
import Kingfisher

struct PostGridView: View {
    
    private let items = [GridItem(), GridItem(), GridItem()]
    
    private let width = UIScreen.main.bounds.width / 3
    let config: PostGridConfiguration
    @ObservedObject var viewModel: PostGridViewModel
    
    init(config: PostGridConfiguration) {
        self.config = config
        self.viewModel = PostGridViewModel(config: config)
    }
    
    var body: some View {
        LazyVGrid(columns: items, spacing: 2) {
            ForEach(viewModel.posts) { post in
                NavigationLink {
                    FeedCell(viewModel: FeedCellViewModel(post: post))
                } label: {
                    KFImage(URL(string: post.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: width)
                        .clipped()
                }

            }
        }
    }
}
