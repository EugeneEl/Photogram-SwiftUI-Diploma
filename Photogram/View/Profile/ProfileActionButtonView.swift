//
//  ProfileActionButtonView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 08.05.2023.
//

import SwiftUI

struct ProfileActionButtonView: View {
    
    @State var showEditProfile = false
    
    @ObservedObject var viewModel: ProfileViewModel
    var isFollowed: Bool {
        return viewModel.user.isFollowed ?? false
    }
    
    var body: some View {
        if viewModel.user.isCurrentUser {
            // Profile button
            Button {
                showEditProfile.toggle()
            } label: {
                Text("Edit Profile")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 360, height: 32)
                    .foregroundColor(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.gray, lineWidth: isFollowed ? 1 : 0))
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(user: $viewModel.user)
            }
        } else {
            // Follow and message button
            HStack {
                Button {
                    isFollowed ? viewModel.unfollow() : viewModel.follow()
                } label: {
                    Text(isFollowed ? "Following" : "Follow")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 172, height: 32)
                        .foregroundColor(isFollowed ? .black : .white)
                        .background(isFollowed ? .white : .blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.gray, lineWidth: 1))
                }.cornerRadius(3)
                
                Button {
                    
                } label: {
                    Text("Message")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 172, height: 32)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.gray, lineWidth: 1))
                }
            }
        }
    }
}

