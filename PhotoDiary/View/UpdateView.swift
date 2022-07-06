//
//  UpdateView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/23.
//

import SwiftUI

struct UpdateView: View {
    @ObservedObject var diaryViewModel: DiaryViewModel
    @ObservedObject var diary: Diary
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingAlert = false
    @State var photo: UIImage
    @State var title: String
    @State var content: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Image(uiImage: photo).resizable().scaledToFill()
                    }
                }
                Section {
                    TextField(diary.title, text: $title)
                }
                Section {
                    TextField(diary.content, text: $content)
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .navigationTitle("다이어리 수정")
        }
        Spacer()
        Button {
            diaryViewModel.updateDiary(id: diary.id, photo: photo, title: title, content: content) { isWriter in
                switch isWriter {
                case true:
                    self.presentationMode.wrappedValue.dismiss()
                case false:
                    self.showingAlert = true
                }
            }
        } label: {
            Text("수정 완료")
        }
        .buttonStyle(.borderedProminent)
        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || content.trimmingCharacters(in: .whitespaces).isEmpty)
        .padding(.bottom, 10)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("업데이트 불가"), message: Text("이 다이어리를 생성한 본인이 아니기 때문에 수정할 수 없습니다."), dismissButton: .default(Text("확인")))
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        photo = inputImage
    }
}
