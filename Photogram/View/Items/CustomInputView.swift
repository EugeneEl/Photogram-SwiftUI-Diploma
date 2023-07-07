//
//  CustomInputView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 12.06.2023.
//

import SwiftUI

struct CustomInputView: View {
    @Binding var inputText: String
    var action: () -> Void

    /// The separator line of the input view
    private var separator: some View {
        Rectangle()
            .foregroundColor(Color(.separator))
            .frame(width: UIScreen.main.bounds.width, height: 0.75)
            .padding(.bottom, 8)
    }
    
    /// The send button of the input view
    private var sendButton: some View {
        Button(action: action) {
            Text("Send")
                .bold()
                .foregroundColor(.black)
        }
    }
    
    var body: some View {
        VStack {
            separator
            
            HStack {
                TextField("Comment...", text: $inputText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(minHeight: 30)
                
                sendButton
            }
            .padding(.bottom, 8)
            .padding(.horizontal)
        }
    }
}
