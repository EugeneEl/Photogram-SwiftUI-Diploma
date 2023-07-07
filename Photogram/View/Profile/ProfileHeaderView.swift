//
//  ProfileHeaderView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 05.05.2023.
//

import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                KFImage(URL(string: viewModel.user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.leading)
                
                Spacer()
                
                HStack(spacing: 16) {
                    if let stats = viewModel.user.stats {
                        UserStatView(value: stats.posts, title: "Post")
                        UserStatView(value: stats.followers, title: "Followers")
                        UserStatView(value: stats.following, title: "Following")
                    } else {
                        UserStatView(value: 0, title: "Post")
                        UserStatView(value: 0, title: "Followers")
                        UserStatView(value: 0, title: "Following")
                    }
                }
                .padding(.trailing, 32)
            }
            Text(viewModel.user.fullname)
                .font(.system(size: 15, weight: .semibold))
                .padding([.leading, .top])
            
            if let text = viewModel.user.bio {
                Text(text)
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.leading)
                    .padding(.top, 1)
            }

            HStack {
                Spacer()
                ProfileActionButtonView(viewModel: viewModel)
                
                Spacer()
            }.padding(.top)
        }
    }
}
