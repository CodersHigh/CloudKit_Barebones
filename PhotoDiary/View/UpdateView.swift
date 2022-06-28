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
            if title.isEmpty || content.isEmpty {
                showingAlert = true
            } else {
                diaryViewModel.updateDiary(id: diary.id, photo: photo, title: title, content: content)
                self.presentationMode.wrappedValue.dismiss()
                diaryViewModel.fetchDiary()
            }
        } label: {
            Text("수정 완료")
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
