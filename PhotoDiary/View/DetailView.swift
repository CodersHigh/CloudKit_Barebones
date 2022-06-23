//
//  DetailView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/22.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var diary: Diary
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(diary: Diary(photo: UIImage(), title: "", content: "", date: Date()))
    }
}
