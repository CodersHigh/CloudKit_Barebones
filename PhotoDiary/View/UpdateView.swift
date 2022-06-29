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
            diaryViewModel.updateDiary(id: diary.id, photo: photo, title: title, content: content)
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("수정 완료")
        }
        .buttonStyle(.borderedProminent)
        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || content.trimmingCharacters(in: .whitespaces).isEmpty)
        .padding(.bottom, 10)
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        photo = inputImage
    }
}
