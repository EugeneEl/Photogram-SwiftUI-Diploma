//
//  EditProfileViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 06.07.2023.
//

import Foundation

class EditProfileViewModel: ObservableObject {
    var user: User
    @Published var uploadCompete = false
    
    init(user: User) {
        self.user = user
    }
    
    func saveUserBio(_ bio: String) {
        guard let id = user.id else {return}
        COLLECTION_USERS.document(id).updateData(["bio": bio]) { _ in
            print("DEBUG: Successfully updated bio..")
            self.user.bio = bio
            self.uploadCompete = true
        }
    }
}
