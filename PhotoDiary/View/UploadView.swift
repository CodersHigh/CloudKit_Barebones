//
//  UploadView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/23.
//

import SwiftUI

struct UploadView: View {
    @ObservedObject var viewModel = DiaryViewModel()
    @State private var photo: UIImage?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if photo == nil {
                        Button {
                            showingImagePicker = true
                        } label: {
                            Text("사진을 추가하자")
                        }
                    } else {
                        Image(uiImage: photo!)
                            .resizable()
                            .scaledToFill()
                    }
                }
                Section {
                    TextField("오늘의 제목", text: $title)
                }
                Section {
                    TextField("오늘 어떤 일이 있었나요?", text: $content)
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .navigationTitle("New Diary")
        }
        Spacer()
        Button {
            if photo == nil || title.isEmpty || content.isEmpty {
                showingAlert = true
            } else {
                viewModel.uploadDiary(photo: photo!, title: title, content: content)
                self.presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("작성 완료")
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom, 10)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("업로드 불가"), message: Text("아직 다이어리를 다 작성하지 못했어요."), dismissButton: .cancel(Text("확인")))
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        photo = inputImage
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
