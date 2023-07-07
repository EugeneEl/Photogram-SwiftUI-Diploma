//
//  ResetPasswordView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 09.05.2023.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment (\.presentationMode) var mode
    @Binding private var email: String
    
    // Custom initialization to bind email
    init(email: Binding<String>) {
        self._email = email
    }
    
    var body: some View {
        ZStack {
            BackgroundGradient() // extracted gradient as separate view
            
            VStack {
                AppLogo() // extracted Image as a separate view

                EmailField(email: $email) // extracted Email Field

                ResetPasswordButton(email: $email) // extracted button
                
                Spacer()
                
                AlreadyHaveAnAccountButton() // extracted button
                
            }.onReceive(viewModel.$didSendResetPasswordLink) { didSend in
                self.mode.wrappedValue.dismiss()
            }
        }
    }
}

// MARK: - Extracted Custom Views

struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

struct AppLogo: View {
    var body: some View {
        Image(systemName: "camera")
            .resizable()
            .scaledToFit()
            .frame(width: 220, height: 100)
            .foregroundColor(.white)
    }
}

struct EmailField: View {
    @Binding var email: String
    var body: some View {
        CustomTextField(text: $email, placeholder: Text("Email"), imgName: "envelope")
            .padding()
            .background(Color(.init(white: 1, alpha: 0.15)))
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
    }
}

struct ResetPasswordButton: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var email: String
    var body: some View {
        Button {
            viewModel.resetPassword(with: email)
        } label: {
            Text("Send reset password link")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 360, height: 50)
                .background(Color.purple)
                .clipShape(Capsule())
        }
    }
}

struct AlreadyHaveAnAccountButton: View {
    @Environment (\.presentationMode) var mode
    var body: some View {
        Button {
            mode.wrappedValue.dismiss()
        } label: {
            HStack {
                Text("Already have an account?")
                    .font(.system(size: 14))
                Text("Sign In")
                    .font(.system(size: 14, weight: .semibold))
            }.foregroundColor(.white)
        }.padding(.bottom, 32)
    }
}
