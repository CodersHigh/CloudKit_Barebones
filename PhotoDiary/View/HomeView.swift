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
    
    var body: some View {
        NavigationView {
            VStack {
                List(diaryViewModel.diaries) { diary in
                    NavigationLink(destination: DetailView(diaryViewModel: diaryViewModel, diary: diary)) {
                        VStack {
                            Text(diary.title)
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                            Image(uiImage: diary.photo )
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            diaryViewModel.deleteDiary(id: diary.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
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
            .navigationTitle("My Photo Diary")
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
