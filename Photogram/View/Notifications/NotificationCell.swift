//
//  NotificationCell.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 04.05.2023.
//

import SwiftUI
import Kingfisher

struct NotificationCell: View {
    @ObservedObject var viewModel: NotificationCellViewModel
    @State private var showPostImage = false
    
    init(viewModel: NotificationCellViewModel) {
        self.viewModel = viewModel
    }
    
    var isFollowed: Bool {
        return viewModel.notification.isFollowed ?? false
    }
    
    var body: some View {
        HStack {
            UserImageWithText(viewModel: viewModel)
            
            Spacer()
            
            FollowOrPostPreview(viewModel: viewModel, isFollowed: isFollowed)
        }
        .padding(.horizontal)
    }
}

// MARK: - Custom Subviews

struct UserImageWithText: View {
    @ObservedObject var viewModel: NotificationCellViewModel

    var body: some View {
        if let user = viewModel.notification.user {
            NavigationLink(destination: ProfileView(user: user)) {
                HStack {
                    ProfileImage(url: viewModel.notification.profileImageUrl)
                    TextMessage(viewModel: viewModel)
                }
            }
        }
    }
}

struct ProfileImage: View {
    let url: String

    var body: some View {
        KFImage(URL(string: url))
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

struct TextMessage: View {
    @ObservedObject var viewModel: NotificationCellViewModel

    var body: some View {
        Text(viewModel.notification.username)
            .font(.system(size: 14, weight: .semibold)) +
        Text(viewModel.notification.type.notificationMessage) +
        Text(viewModel.timestampString)
            .foregroundColor(.gray)
            .font(.system(size: 12))
    }
}

struct FollowOrPostPreview: View {
    @ObservedObject var viewModel: NotificationCellViewModel
    let isFollowed: Bool

    var body: some View {
        if viewModel.notification.type != .follow {
            if let post = viewModel.notification.post {
                PostPreview(viewModel: viewModel, post: post)
            }
        } else {
            FollowButton(viewModel: viewModel, isFollowed: isFollowed)
        }
    }
}

struct PostPreview: View {
    @ObservedObject var viewModel: NotificationCellViewModel
    let post: Post

    var body: some View {
        NavigationLink {
            FeedCell(viewModel: FeedCellViewModel(post: post))
        } label: {
            KFImage(URL(string: post.imageURL))
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipped()
        }
    }
}

struct FollowButton: View {
    @ObservedObject var viewModel: NotificationCellViewModel
    let isFollowed: Bool

    var body: some View {
        Button {
            isFollowed ? viewModel.unfollow() : viewModel.follow()
        } label: {
            Text(isFollowed ? "Following" : "Follow")
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 100, height: 32)
                .foregroundColor(isFollowed ? .black : .white)
                .background(isFollowed ? .white : .blue)
                .cornerRadius(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.gray, lineWidth: isFollowed ? 1 : 0))
        }
    }
}
