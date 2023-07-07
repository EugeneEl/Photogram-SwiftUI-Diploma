//
//  AuthViewModel.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 16.05.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var didSendResetPasswordLink: Bool = false
    
    static let shared = AuthViewModel()
    
    private init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Error signing in \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
            print("DEBUG: Successfully logged in user")
        }
        print("login")
    }
    
    func register(with email: String, password: String, image: UIImage?, fullname: String, username: String) {
        print("email: \(email)")
        print("password: \(password)")
        print("register")
        
        guard let image =  image else {return}
        
        ImageUploader.uploadImage(image: image, type: .profile) { imageURL in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("DEBUG: Error signing up \(error.localizedDescription)")
                    return
                }
                
                print("DEBUG: Successfully registered user")
                guard let user = result?.user else { return }
                self.userSession = user
                print("Successfull registered user...")
                
                let data = ["email": email,
                            "username": username,
                            "fullname": fullname,
                            "profileImageUrl": imageURL,
                            "uid": user.uid]
                
                COLLECTION_USERS.document(user.uid).setData(data) { _ in
                    print("DEBUG: Successfully uploaded user data...")
                }
                
                print("DEBUG: successfully uploaded user")
            }
        }
    }
    
    func resetPassword(with email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("DEBUG: Error sending password reset \(error.localizedDescription)")
                return
            }
            
            self.didSendResetPasswordLink = true
            print("DEBUG: Did send password reset")
        }
    }
    
    func signOut() {
        self.userSession = nil
        try? Auth.auth().signOut()
    
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else {return}
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let dictionary = snapshot?.data() else { return }
            guard let user = try? snapshot?.data(as: User.self) else {return}
            self.currentUser = user
            print("DEGUB: User is \(user)")
        }
    }
}
