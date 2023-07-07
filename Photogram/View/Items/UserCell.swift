//
//  UserCell.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 04.05.2023.
//

import SwiftUI
import Kingfisher

// MARK: - UserCell
struct UserCell: View {
    let user: User

    // MARK: - Body
    var body: some View {
        HStack {
            ProfileImageView(user: user)
            UserDetailsView(user: user)
            Spacer()
        }
    }
    
    // MARK: - ProfileImageView
    /// View to display the user's profile image.
    private struct ProfileImageView: View {
        let user: User
        
        var body: some View {
            // Use Kingfisher to download and cache images from the web.
            KFImage(URL(string: user.profileImageUrl))
                .resizable() // make image resizable.
                .scaledToFill() // fill the frame.
                .frame(width: 48, height: 48) // specify the frame.
                .clipShape(Circle()) // clip to circle shape.
        }
    }
    
    // MARK: - UserDetailsView
    /// View to display the user's details - username and fullname.
    private struct UserDetailsView: View {
        let user: User
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.system(size: 14, weight: .semibold)) // username with semi-bold font.
                
                Text(user.fullname)
                    .font(.system(size: 14)) // fullname with regular font.
            }
        }
    }
}
