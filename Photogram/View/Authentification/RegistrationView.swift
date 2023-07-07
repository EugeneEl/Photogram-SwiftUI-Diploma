//
//  RegistrationView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 09.05.2023.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var username = ""
    @State private var password = ""
    @State private var selectedImage: UIImage?
    @State var image: Image?
    @Environment (\.presentationMode) var mode
    @State var imagePickerPresented = false
    @EnvironmentObject var viewModel: AuthViewModel
   
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .padding(.top, 44)
                    } else {
                        Button {
                            imagePickerPresented.toggle()
                        } label: {
                            Image("plus_icon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 100)
                                 .foregroundColor(.white)
                        }
                        .sheet(isPresented: $imagePickerPresented, onDismiss: {
                            loadImage()
                        }) {
                            ImagePicker(image: $selectedImage)
                        }
                        .padding()
                    }
                }
                
                // Registration fields
                RegistrationFields(email: $email,
                                   username: $username,
                                   fullname: $fullname,
                                   password: $password)

                HStack {
                    Spacer()
                    
                    Button {
  
                    } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.top)
                            .padding(.trailing, 28)
                    }

                }
                
                // Sign in
                
                Button {
                    viewModel.register(with: email, password: password, image: selectedImage, fullname: fullname, username: username)
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 50)
                        .background(Color.purple)
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Text("Already have an account")
                                .font(.system(size: 14))
                            
                            Text("Sign In")
                                .font(.system(size: 14))
                        }.foregroundColor(.white)
                    }
                }.padding(.bottom, 32)
            }
        }
    }
}

// New struct for registration fields
struct RegistrationFields: View {
    @Binding var email: String
    @Binding var username: String
    @Binding var fullname: String
    @Binding var password: String

    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $email, placeholder: Text("Email"), imgName: "envelope")
                .padding()
                .background(Color(.init(white: 1, alpha: 0.15)))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                
            CustomTextField(text: $username, placeholder: Text("Username"), imgName: "person")
                .padding()
                .background(Color(.init(white: 1, alpha: 0.15)))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
            
            CustomTextField(text: $fullname, placeholder: Text("Full Name"), imgName: "person")
                .padding()
                .background(Color(.init(white: 1, alpha: 0.15)))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                                
            CustomSecureTextField(text: $password, placeholder: Text("Password"))
                .padding()
                .background(Color(.init(white: 1, alpha: 0.15)))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
        }
    }
}

extension RegistrationView {
    func loadImage() {
        guard let selectedImage = selectedImage else {return}
        image = Image(uiImage: selectedImage)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
