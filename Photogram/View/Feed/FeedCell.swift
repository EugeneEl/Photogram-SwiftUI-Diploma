//
//  FeedCell.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 02.05.2023.
//

import SwiftUI
import Kingfisher

struct FeedCell: View {
    @ObservedObject var viewModel: FeedCellViewModel
    
    var didLike: Bool { return viewModel.post.didLike ?? false }
    
    init(viewModel: FeedCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            PostOwnerView(viewModel: viewModel)
            PostImageView(viewModel: viewModel)
            ActionButtonsView(viewModel: viewModel, didLike: didLike)
            CaptionView(viewModel: viewModel)
        }
    }
}

// MARK: - Custom Subviews

private struct PostOwnerView: View {
    @ObservedObject var viewModel: FeedCellViewModel

    var body: some View {
        HStack {
            ProfileImageView(viewModel: viewModel)
            Text(viewModel.post.ownerUsername)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding([.leading, .bottom], 8)
    }
}

private struct ProfileImageView: View {
    @ObservedObject var viewModel: FeedCellViewModel

    var body: some View {
        KFImage(URL(string: viewModel.post.ownerImageUrl))
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .clipped()
            .cornerRadius(18)
    }
}

private struct PostImageView: View {
    @ObservedObject var viewModel: FeedCellViewModel

    var body: some View {
        KFImage(URL(string: viewModel.post.imageURL))
            .resizable()
            .scaledToFill()
            .frame(maxHeight: 440)
            .clipped()
    }
}

private struct ActionButtonsView: View {
    @ObservedObject var viewModel: FeedCellViewModel
    let didLike: Bool

    var body: some View {
        HStack(spacing: 16) {
            LikeButtonView(viewModel: viewModel, didLike: didLike)
            CommentButtonView(viewModel: viewModel)
            ShareButtonView()
        }
        .padding(.leading, 4)
        .foregroundColor(.black)
    }
}

private struct LikeButtonView: View {
    @ObservedObject var viewModel: FeedCellViewModel
    let didLike: Bool

    var body: some View {
        Button {
            didLike ? viewModel.unlike() : viewModel.like()
        } label: {
            Image(systemName: didLike ? "heart.fill" : "heart")
                .resizable()
                .scaledToFill()
                .foregroundColor(didLike ? .red : .black)
                .frame(width: 20, height: 20)
                .font(.system(size: 20))
                .padding(4)
        }
    }
}

private struct CommentButtonView: View {
    @ObservedObject var viewModel: FeedCellViewModel

    var body: some View {
        NavigationLink(destination: CommentsView(post: viewModel.post)) {
            Image(systemName: "bubble.right")
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .font(.system(size: 20))
                .padding(4)
        }
    }
}

private struct ShareButtonView: View {
    var body: some View {
        Button {
        } label: {
            Image(systemName: "paperplane")
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .font(.system(size: 20))
                .padding(4)
        }
    }
}

private struct CaptionView: View {
    @ObservedObject var viewModel: FeedCellViewModel

    var body: some View {
        Group {
            Text("\(viewModel.likeString)")
                .font(.system(size: 14, weight: .semibold))
                .padding(.leading, 8)
                .padding(.bottom, 2)
            
            HStack {
                Text(viewModel.post.ownerUsername)
                    .font(.system(size: 14, weight: .semibold)) + Text(" \(viewModel.post.caption)")
                    .font(.system(size: 15))
            }
            .padding(.horizontal, 8)
            
            Text(viewModel.timestampString)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding([.leading], 8)
                .padding(.top, -2)
        }
    }
}

