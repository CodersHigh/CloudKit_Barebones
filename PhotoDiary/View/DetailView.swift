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
    @State private var showingUpdateSheet = false
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Image(uiImage: diary.photo)
                        .resizable()
                        .scaledToFit()
                }
                Section {
                    VStack(alignment: .leading) {
                        Text(diary.title)
                            .font(.title3.bold())
                            .padding(.top, 10)
                            .padding(.bottom, 2)
                        Text(diary.content)
                            .font(.body)
                            .padding(.bottom, 10)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Section {
                    Text(diary.date)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Button {
                showingUpdateSheet.toggle()
            } label: {
                Text("다이어리 수정")
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 10)
        }
        .sheet(isPresented: $showingUpdateSheet, content: {
            UpdateView(diary: diary)
        })
    }
}


