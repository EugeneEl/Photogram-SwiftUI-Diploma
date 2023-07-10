//
//  LoginView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 09.05.2023.
//

import SwiftUI

// MARK: - LoginView

struct LoginView: View {
    
    // MARK: - Properties

    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                // Add the background gradient
                BackgroundGradient()
                
                VStack {
                    // Add the login header
                    LoginHeader()
                    
                    // Add the login fields (email and password)
                    LoginFields(email: $email, password: $password)
                    
                    // Add a link to reset password
                    ForgotPasswordLink(email: $email)
                    
                    // Add the sign in button
                    SignInButton(action: {
                        viewModel.login(withEmail: email, password: password)
                    })
                    
                    Spacer()
                    
                    // Add a button for new user registration
                    SignUpButton()
                }
            }
        }
        .tint(.white)
    }
}

// MARK: - Login Header

private struct LoginHeader: View {
    var body: some View {
        Image(systemName: "camera")
            .resizable()
            .scaledToFit()
            .frame(width: 220, height: 100)
            .foregroundColor(.white)
    }
}

// MARK: - Login Fields

private  struct LoginFields: View {
    @Binding var email: String
    @Binding var password: String

    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $email, placeholder: Text("Email"), imgName: "envelope")
                .textFieldStyle()
            
            CustomSecureTextField(text: $password, placeholder: Text("Password"))
                .textFieldStyle()
        }
    }
}

// MARK: - TextFieldStyle Extension

private extension View {
    func textFieldStyle() -> some View {
        self.padding()
            .background(Color(.init(white: 1, alpha: 0.15)))
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .tint(.white)
    }
}

// MARK: - Forgot Password Link

private struct ForgotPasswordLink: View {
    @Binding var email: String

    var body: some View {
        HStack {
            Spacer()
            NavigationLink {
                ResetPasswordView(email: $email)
            } label: {
                Text("Forgot Password?")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.top)
                    .padding(.trailing, 28)
            }
        }
    }
}

// MARK: - Sign In Button

private  struct SignInButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Sign in")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 360, height: 50)
                .background(Color.purple)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Sign Up Button

private struct SignUpButton: View {
    var body: some View {
        NavigationLink {
            RegistrationView()
                .navigationBarHidden(true)
        } label: {
            TextsInHStack(firstText: "Don't have an account?", secondText: "Sign Up")
        }.padding(.bottom, 32)
    }
}

// MARK: - Texts in Horizontal Stack

struct TextsInHStack: View {
    let firstText: String
    let secondText: String

    var body: some View {
        HStack {
            Text(firstText).font(.system(size: 14))
            Text(secondText).font(.system(size: 14))
        }.foregroundColor(.white)
    }
}
