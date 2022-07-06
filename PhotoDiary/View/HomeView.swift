//
//  ContentView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var diaryViewModel = DiaryViewModel()
    @State private var showingUploadSheet = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(diaryViewModel.diaries) { diary in
                    NavigationLink(destination: DetailView(diaryViewModel: diaryViewModel, diary: diary)) {
                        VStack {
                            Text(diary.title)
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                            Text(diary.date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Image(uiImage: diary.photo )
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            diaryViewModel.deleteDiary(id: diary.id) { isWriter in
                                switch isWriter {
                                case true:
                                    diaryViewModel.fetchDiary()
                                case false:
                                    self.showingAlert = true
                                }
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("삭제 불가"), message: Text("이 다이어리를 생성한 본인이 아니기 때문에 삭제할 수 없습니다."), dismissButton: .default(Text("확인")))
                    }
                }
                Spacer()
                Button {
                    showingUploadSheet.toggle()
                } label: {
                    Text("다이어리 작성")
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 10)
            }
            .navigationTitle("Photo Diary")
            .navigationViewStyle(.stack)
            .onAppear() {
                diaryViewModel.fetchDiary()
            }
            .sheet(isPresented: $showingUploadSheet, content: {
                UploadView(diaryViewModel: diaryViewModel)
            })
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
