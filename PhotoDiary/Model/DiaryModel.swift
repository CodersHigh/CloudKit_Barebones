//
//  DiaryModel.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/22.
//

import Foundation
import UIKit
import CloudKit

class Diary: Identifiable, ObservableObject {
    let photo: UIImage
    let title: String
    let content: String
    let date: Date
    
    /*
    init(photo: UIImage, title: String, content: String, date: Date) {
        self.photo = photo
        self.title = title
        self.content = content
        self.date = date
    }
     */
    init(record: CKRecord) {
        var photo: UIImage?
        let asset = record["photo"] as! CKAsset
        do {
            let imageData = try Data(contentsOf: asset.fileURL!)
            photo = UIImage(data: imageData)
        } catch {
            print("사진 받다가 에러 났어!")
        }
        self.photo = photo ?? UIImage()
        self.title = record["title"] as! String
        self.content = record["content"] as! String
        self.date = record["date"] as! Date
    }
}
