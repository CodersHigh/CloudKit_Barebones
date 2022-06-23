//
//  ContentView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = DiaryViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.diaries) { diary in
                    NavigationLink(destination: DetailView(diary: diary)) {
                        VStack {
                            Text(diary.title)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .padding(.bottom, 1)
                                .padding(.top, 2)
                            Image(uiImage: diary.photo )
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.deleteDiary(id: diary.id, completion: viewModel.fetchDiary)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                Spacer()
                Button {
                    
                } label: {
                    Text("다이어리 작성")
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 10)
            }
            .navigationTitle("My Photo Diary")
            .navigationViewStyle(.stack)
            .onAppear() {
                viewModel.fetchDiary()
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
