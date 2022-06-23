//
//  DiaryModelView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/22.
//

import Foundation
import CloudKit
import UIKit

class DiaryViewModel: ObservableObject {
    @Published var diaries = [Diary]()
    
    func fetchDiary() {
        let query = CKQuery(recordType: "Diary", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) {
            records, error in
            if let error = error {
                print("에러다!!: \(error.localizedDescription)")
                return
            }
            guard let records = records else { return }
            DispatchQueue.main.async {
                self.diaries = records.map { record in
                    var photo: UIImage?
                    let asset = record["photo"] as! CKAsset
                    do {
                        let imageData = try Data(contentsOf: asset.fileURL!)
                        photo = UIImage(data: imageData)
                    } catch {
                        print("사진 받다가 에러 났어!")
                    }
                    let title = record["title"] as! String
                    let content = record["content"] as! String
                    let date = record["date"] as! Date
                    return Diary(photo: photo ?? UIImage(), title: title, content: content, date: date)
                }
            }
        }
    }
    
    func uploadDiary(title: String, content: String) {
        
    }
    
    func updateDiary(id: String, title: String, content: String) {
        
    }
    
    func deleteDiary(id: String) {
        
    }
    
}
