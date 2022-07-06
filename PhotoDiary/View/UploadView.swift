//
//  UploadView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/23.
//

import SwiftUI

struct UploadView: View {
    @ObservedObject var diaryViewModel: DiaryViewModel
    @State private var photo: UIImage?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingAlert = false
    @State private var title: String = ""
    @State private var content: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        if photo == nil {
                            Text("사진을 추가해")
                        } else {
                            Image(uiImage: photo!).resizable().scaledToFill()
                        }
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
            diaryViewModel.uploadDiary(photo: photo!, title: title, content: content) { loginICloud in
                switch loginICloud {
                case true :
                    self.presentationMode.wrappedValue.dismiss()
                case false :
                    self.showingAlert = true
                }
            }
        } label: {
            Text("작성 완료")
        }
        .buttonStyle(.borderedProminent)
        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || content.trimmingCharacters(in: .whitespaces).isEmpty || photo == nil)
        .padding(.bottom, 10)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("업로드 불가"), message: Text("기기에서 iCloud 계정으로 로그인 되어 있는지 확인하세요."), dismissButton: .default(Text("확인")))
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        photo = inputImage
    }
}
