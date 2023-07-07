//
//  UserListView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 04.05.2023.
//

import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @Binding var searchText: String
    
    var users: [User] {
        return searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(users) { user in
                    NavigationLink {
                        LazyContentView(ProfileView(user: user))
                    } label: {
                        UserCell(user: user)
                            .padding(.leading)
                    }
                }
            }
        }
    }
}
