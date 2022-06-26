//
//  DiaryModelView.swift
//  PhotoDiary
//
//  Created by 이로운 on 2022/06/22.
//

import Foundation
import CloudKit
import UIKit
import SwiftUI

class DiaryViewModel: ObservableObject {
    @Published var diaries = [Diary]()
    
    func fetchDiary() {
        let query = CKQuery(recordType: "Diary", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) {
            records, error in
            if let error = error {
                print("fetch error: \(error.localizedDescription)")
                return
            } 
            guard let records = records else { return }
            DispatchQueue.main.async {
                self.diaries = records.map { record in
                    return Diary(record: record)
                }
            }
        }
    }
    
    func uploadDiary(photo: UIImage, title: String, content: String) {
        let record = CKRecord(recordType: "Diary")
        
        guard let imageData = photo.jpegData(compressionQuality: 1.0) else { return }
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("photo")
        do {
            try imageData.write(to: url!)
            let asset = CKAsset(fileURL: url!)
            record.setValue(asset, forKey: "photo")
        } catch {
            print(error.localizedDescription)
        }
        record.setValue(Date(), forKey: "date")
        record.setValue(title, forKey: "title")
        record.setValue(content, forKey: "content")
        CKContainer.default().publicCloudDatabase.save(record) { savedRecord, error in
            if let error = error {
                print("upload error: \(error.localizedDescription)")
            }
            self.fetchDiary()
        }
    }
    
    func updateDiary(id: CKRecord.ID, photo: UIImage, title: String, content: String) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { updatedRecord, error in
            if let error = error {
                print("update error: \(error.localizedDescription)")
            }
            guard let imageData = photo.jpegData(compressionQuality: 1.0) else { return }
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("photo")
            do {
                try imageData.write(to: url!)
                let asset = CKAsset(fileURL: url!)
                updatedRecord?.setValue(asset, forKey: "photo")
            } catch {
                print(error.localizedDescription)
            }
            updatedRecord?.setValue(Date(), forKey: "date")
            updatedRecord?.setValue(title, forKey: "title")
            updatedRecord?.setValue(content, forKey: "content")
            CKContainer.default().publicCloudDatabase.save(updatedRecord!) { savedRecord, error in
                if let error = error {
                    print("update error: \(error.localizedDescription)")
                }
                self.fetchDiary()
            }
        }
    }
    
    func deleteDiary(id: CKRecord.ID) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: id) { deletedRecordId, error  in
            if let error = error {
                print("delete error: \(error.localizedDescription)")
            }
            self.fetchDiary()
        }
    }
    
}
