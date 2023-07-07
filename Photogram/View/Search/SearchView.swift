//
//  SearchView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 02.05.2023.
//

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @State var inSearchMode = true
    @ObservedObject var viewModel = SearchViewModel()
     
    var body: some View {
        ScrollView {
            Text("Search")
            // search bar
            SearchBar(text: $searchText, isEditing: $inSearchMode)
                .padding()
            // grid view
            
            ZStack {
                if inSearchMode {
                    UserListView(viewModel: viewModel, searchText: $searchText)
                } else {
                    PostGridView(config: .explore)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
