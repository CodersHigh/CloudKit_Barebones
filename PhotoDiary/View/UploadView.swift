//
//  UploadView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/23.
//

import SwiftUI

struct UploadView: View {
    @State private var photo: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if photo == nil {
                        Button {
                            showImagePicker = true
                        } label: {
                            Text("사진을 추가하자")
                        }
                    }
                    photo?.resizable().scaledToFit()
                }
            }
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .navigationTitle("New Diary")
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        photo = Image(uiImage: inputImage)
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
