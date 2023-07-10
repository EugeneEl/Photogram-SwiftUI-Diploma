//
//  UploadPostView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 02.05.2023.
//

import SwiftUI

struct UploadPostView: View {
    @State private var selectedImage: UIImage?
    @State var postImage: Image?
    @State var captionText = ""
    @State var imagePickerPresented = false
    @Binding var tabIndex: Int
    @ObservedObject var viewModel = UploadPostViewModel()
    
    var body: some View {
        VStack {
            VStack {
                if postImage == nil {
                    Spacer()
                    AddImageButton(imagePickerPresented: $imagePickerPresented)
                        .sheet(isPresented: $imagePickerPresented, onDismiss: loadImage) {
                            ImagePicker(image: $selectedImage)
                        }
                    Spacer()
                } else if let image = postImage {
                    PostEditorView(postImage: image, captionText: $captionText)
                    PostActionsView(captionText: $captionText, postImage: $postImage, tabIndex: $tabIndex, viewModel: viewModel, selectedImage: $selectedImage)
                }
            }
            .padding()
            Spacer()
        }
    }

    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        postImage = Image(uiImage: selectedImage)
    }
}

// MARK: - Custom Subviews

private struct AddImageButton: View {
    @Binding var imagePickerPresented: Bool

    var body: some View {
        Button {
            imagePickerPresented.toggle()
        } label: {
            Image("plus_icon")
                .resizable()
                .renderingMode(.template)
                .scaledToFill()
                .frame(width: 180, height: 180)
                .clipped()
                .padding(.top, 56)
                .foregroundColor(.black)
        }
    }
}

private struct PostEditorView: View {
    let postImage: Image
    @Binding var captionText: String

    var body: some View {
        HStack(alignment: .top) {
            postImage
                .resizable()
                .scaledToFill()
                .frame(width: 96, height: 96)
                .clipped()

            TextArea(text: $captionText, placeholder: "Enter your caption..")
                .frame(height: 200)
        }
    }
}

private struct PostActionsView: View {
    @Binding var captionText: String
    @Binding var postImage: Image?
    @Binding var tabIndex: Int
    @ObservedObject var viewModel: UploadPostViewModel
    @Binding var selectedImage: UIImage?

    var body: some View {
        HStack {
            CancelButton(captionText: $captionText, postImage: $postImage)
            ShareButton(captionText: $captionText, postImage: $postImage, tabIndex: $tabIndex, viewModel: viewModel, selectedImage: $selectedImage)
        }
    }
}

private struct CancelButton: View {
    @Binding var captionText: String
    @Binding var postImage: Image?

    var body: some View {
        Button {
            captionText = ""
            postImage = nil
        } label: {
            Text("Cancel")
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 172, height: 50)
                .background(Color.red)
                .cornerRadius(5)
                .foregroundColor(.white)
        }
    }
}

private struct ShareButton: View {
    @Binding var captionText: String
    @Binding var postImage: Image?
    @Binding var tabIndex: Int
    @ObservedObject var viewModel: UploadPostViewModel
    @Binding var selectedImage: UIImage?

    var body: some View {
        Button {
            if let image = selectedImage {
                viewModel.uploadPost(caption: captionText, image: image) { _ in
                    captionText = ""
                    selectedImage = nil
                    tabIndex = 0
                }
            }
        } label: {
            Text("Share")
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 172, height: 50)
                .background(Color.blue)
                .cornerRadius(5)
                .foregroundColor(.white)
        }
    }
}
