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

enum RecordType: String {
    case diary = "Diary"
}

class DiaryViewModel: ObservableObject {
    
    @Published var diaries = [Diary]()
    
    // 다이어리 데이터 불러오기 - Read
    func fetchDiary() {
        
        var diaries: [Diary] = []
        
        let query = CKQuery(recordType: RecordType.diary.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        CKContainer.default().publicCloudDatabase.fetch(withQuery: query) { result in
            switch result {
            case .success(let result):
                result.matchResults.compactMap { $0.1 }
                .forEach {
                    switch $0 {
                    case .success(let record):
                        diaries.append(Diary(record: record))
                    case .failure(let error):
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    self.diaries = diaries
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func uploadDiary(photo: UIImage, title: String, content: String) {
        let record = CKRecord(recordType: RecordType.diary.rawValue)
        
        guard let imageData = photo.jpegData(compressionQuality: 1.0) else { return }
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("photo")
        do {
            try imageData.write(to: url!)
            let asset = CKAsset(fileURL: url!)
            record.setValue(asset, forKey: "photo")
        } catch {
            print(error)
        }
        record.setValue(Date(), forKey: "date")
        record.setValue(title, forKey: "title")
        record.setValue(content, forKey: "content")
        
        CKContainer.default().publicCloudDatabase.save(record) { newRecord, error in
            if let error = error {
                print(error)
            } else {
                if let newRecord = newRecord {
                    DispatchQueue.main.async {
                        self.diaries.insert(Diary(record: newRecord), at: 0)
                    }
                }
            }
        }
    }
    
    func updateDiary(id: CKRecord.ID, photo: UIImage, title: String, content: String) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { updatedRecord, error in
            
            if let error = error {
                print(error)
            }
            
            guard let imageData = photo.jpegData(compressionQuality: 1.0) else { return }
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("photo")
            do {
                try imageData.write(to: url!)
                let asset = CKAsset(fileURL: url!)
                updatedRecord?.setValue(asset, forKey: "photo")
            } catch {
                print(error)
            }
            updatedRecord?.setValue(Date(), forKey: "date")
            updatedRecord?.setValue(title, forKey: "title")
            updatedRecord?.setValue(content, forKey: "content")
            
            CKContainer.default().publicCloudDatabase.save(updatedRecord!) { newRecord, error in
                if let error = error {
                    print(error)
                } else {
                    if let updatedRecord = updatedRecord {
                        DispatchQueue.main.async {
                            for (index, diary) in self.diaries.enumerated() {
                                if diary.id == updatedRecord.recordID {
                                    self.diaries[index] = Diary(record: updatedRecord)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteDiary(id: CKRecord.ID) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: id) { deletedRecordId, error  in
            if let error = error {
                print(error)
            } else {
                self.fetchDiary()
            }
        }
    }
    
}
