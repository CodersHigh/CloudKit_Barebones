//
//  DetailView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/22.
//

import SwiftUI
import CloudKit

struct DetailView: View {
    @ObservedObject var diary: Diary
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Image(uiImage: diary.photo)
                        .resizable()
                        .scaledToFit()
                }
                Section {
                    VStack {
                        Text(diary.title)
                            .padding(.bottom, 5)
                            .font(.title)
                        Text(diary.content)
                    }
                }
                Section {
                    Text(diary.date)
                }
            }
            Spacer()
            Button {
                
            } label: {
                Text("다이어리 수정")
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 10)
        }
    }
}


