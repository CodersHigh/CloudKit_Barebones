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
                    VStack {
                        Image(uiImage: UIImage() ?? UIImage())
                            .resizable()
                            .scaledToFill()
                        Text("일기 제목")
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.bottom, 1)
                        Text("날짜")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Button {
                    
                } label: {
                    Text("다이어리 쓰기")
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 10)
            }
            .navigationTitle("My Photo Diary")
            .navigationViewStyle(.stack)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
