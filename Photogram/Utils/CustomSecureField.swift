//
//  CustomSecureField.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 09.05.2023.
//

import SwiftUI

struct CustomSecureTextField: View {
    
    @Binding var text: String
    let placeholder: Text
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder.foregroundColor(Color(.init(white: 1, alpha: 0.8)))
                    .padding(.leading, 40)
            }
            
            HStack {
                Image(systemName: "lock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                
                SecureField("", text: $text)
            }
        }
    }
}

struct CustomSecureTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomSecureTextField(text: .constant(""), placeholder: Text("Email"))
            .background(.purple)
    }
}

