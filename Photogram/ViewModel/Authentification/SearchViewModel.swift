//
//  SearchViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 19.05.2023.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var users = [User]()

    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        COLLECTION_USERS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            self.users = documents.compactMap({ try? $0.data(as: User.self) })
            print("DEBUG: self.users \(self.users)")
        }
    }
    
    func filteredUsers(_ query: String) -> [User] {
        let lowercasedQuery = query.lowercased()
        
        return users.filter({ $0.fullname.lowercased().contains(lowercasedQuery) || $0.username.lowercased().contains(lowercasedQuery) })
    }
}
