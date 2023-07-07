//
//  EditProfileView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 04.07.2023.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject private var viewModel: EditProfileViewModel
    @Binding var user: User
    @Environment (\.presentationMode) var mode
    @State private var bioText: String
    
    init(user: Binding<User>) {
        self._user = user
        self._bioText = State(initialValue: _user.wrappedValue.bio ?? "")
        self.viewModel = EditProfileViewModel(user: user.wrappedValue)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    viewModel.saveUserBio(bioText)
                } label: {
                    Text("Done")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            TextArea(text: $bioText, placeholder: "Add bio here...")
                .frame(width: 300, height: 300)
            
            Spacer()
        }
        .onReceive(viewModel.$uploadCompete, perform: { completed in
            if completed {
                self.user.bio = viewModel.user.bio
                self.mode.wrappedValue.dismiss()
            }
        })
    }
}

