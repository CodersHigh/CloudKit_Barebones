//
//  DiaryModel.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/22.
//

import Foundation
import UIKit

class Diary: Identifiable, ObservableObject {
    let photo: UIImage
    let title: String
    let content: String
    let date: Date
    
    init(photo: UIImage, title: String, content: String, date: Date) {
        self.photo = photo
        self.title = title
        self.content = content
        self.date = date
    }
}
