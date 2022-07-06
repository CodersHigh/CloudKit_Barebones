# CloudKit_Barebones
<br/>

### 프로젝트 소개
- CloudKit의 기본적인 기능 구현을 익히는 데에 도움을 주는 Bare-bones 프로젝트입니다.
- CloudKit을 통해 **SwiftUI 기반의 (사진과 함께 일기를 작성하고 공유할 수 있는) 포토 다이어리**를 구현합니다.
- CloudKit을 처음 활용해 보는 경우, 이 프로젝트의 코드를 살펴보면 도움이 됩니다.


https://user-images.githubusercontent.com/74223246/177460042-7aac585a-bd8d-4c3a-83c7-c8fb38d74cc3.mp4


<br/>

### CloudKit이란?   
iCloud를 기반으로 사용자의 iCloud 계정을 통해 앱 데이터를 저장하고 공유할 수 있는 Apple의 원격 데이터 저장 서비스입니다.    
많은 데이터를 사용하지만, 많은 양의 서버 측 로직이 필요하지 않은 iOS 전용 앱에서 사용하기 좋습니다.     
CloudKit을 사용하려면, 우선 [iCloud 연동 및 CloudKit Console 초기 세팅](https://codershigh.notion.site/CloudKit-iCloud-e77b746fb3d6478fa7cc49b262dd3e4f)에 대해 살펴보세요.  

**Database의 종류**    
CloudKit에는 3가지 종류의 데이터베이스가 있고, 상황에 따라 적합한 것을 사용할 수 있습니다.
- **Public Database** : 앱의 공개 데이터베이스
- **Private Database** : 사용자의 개인 데이터베이스
- **Shared Database** : 공유 데이터를 포함하는 데이터베이스

→ CloudKit_Barebones 프로젝트에서는 Public Database를 사용합니다.
<br/>
<br/>
<br/>

### 핵심 코드
CloudKit Database에서 데이터를 **불러오고(fetch), 추가하고(upload), 수정하고(update), 삭제합니다(delete)**   
CloudKit과 상호작용하는 핵심적인 코드를 참고하세요.

```Swift
// 데이터 불러오기
@Published var diaries = [Diary]()

func fetchDiary() {
    var diaries: [Diary] = []
        
    // Diary 데이터를 불러오기 위한 질의 작성
    let query = CKQuery(recordType: RecordType.diary.rawValue, predicate: NSPredicate(value: true))
    query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // 날짜를 기준으로 내림차순 정렬 (최신순) 
        
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
                // 불러온 데이터를 '@Published 프로퍼티 래퍼를 사용해서 선언된 변수 diaries'에 넣기 
                // 참고) @Published를 사용해서 선언된 변수의 값이 변경되면, 해당 변수를 사용한 모든 뷰의 내용이 자동으로 변경된다. 
                self.diaries = diaries
            }
        case .failure(let error):
            print(error)
        }
    }
}
```
```Swift
// 데이터 추가하기 
func uploadDiary(photo: UIImage, title: String, content: String, completion: @escaping (Bool) -> Void) {
    let record = CKRecord(recordType: RecordType.diary.rawValue)
        
    // 이미지 타입을 UIImage에서 CKAsset으로 변경 후, 업로드할 레코드에 setValue
    guard let imageData = photo.jpegData(compressionQuality: 1.0) else { return }
    let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("photo")
    do {
        try imageData.write(to: url!)
        let asset = CKAsset(fileURL: url!)
        record.setValue(asset, forKey: "photo")
    } catch {
        print(error)
    }
    // 날짜, 제목, 콘텐츠 데이터를 업로드할 레코드에 setValue
    record.setValue(Date(), forKey: "date")
    record.setValue(title, forKey: "title")
    record.setValue(content, forKey: "content")
        
    CKContainer.default().publicCloudDatabase.save(record) { newRecord, error in
        if let error = error {
            print(error)
            completion(false)
        } else {
            if let newRecord = newRecord {
                DispatchQueue.main.async {
                    // 새로운 데이터를 '@Published 프로퍼티 래퍼를 사용해서 선언된 변수 diaries' 맨 앞에 추가하기
                    self.diaries.insert(Diary(record: newRecord), at: 0)
                }
                completion(true)
            }
        }
    }
}
```
- `fetchDiary()` 를 사용하지 않고, ‘@Published 변수 diaries’에 추가해 줌으로써 새로운 레코드를 화면에 불러오는 이유는 :    
새로운 레코드가 추가된 즉시 화면에 바로 업데이트하기 위함입니다.. `fetchDiary()` 를 호출하면, 새로운 레코드가 CloudKit DB에 저장되지도 않았는데    
데이터를 불러오는 상황이 되어 추가된 레코드가 화면에 바로 반영되지 않습니다 🚨
```Swift
// 데이터 수정하기 
func updateDiary(id: CKRecord.ID, photo: UIImage, title: String, content: String, completion: @escaping (Bool) -> Void) {

    // 일단 업데이트할 레코드 하나 불러오기 
    CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { updatedRecord, error in
            
        if let error = error {
            print(error)
        }
            
        // 이미지 타입을 UIImage에서 CKAsset으로 변경 후, 업데이트할 레코드에 setValue 
        guard let imageData = photo.jpegData(compressionQuality: 1.0) else { return }
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("photo")
        do {
            try imageData.write(to: url!)
            let asset = CKAsset(fileURL: url!)
            updatedRecord?.setValue(asset, forKey: "photo")
        } catch {
            print(error)
        }
        // 제목, 콘텐츠 데이터를 업데이트할 레코드에 setValue (업데이트할 때 date는 변경되지 않아요) 
        updatedRecord?.setValue(title, forKey: "title")
        updatedRecord?.setValue(content, forKey: "content")
            
        CKContainer.default().publicCloudDatabase.save(updatedRecord!) { newRecord, error in
            if let error = error {
                print(error)
                completion(false)
            } else {
                if let updatedRecord = updatedRecord {
                    DispatchQueue.main.async {
                        // @Published 변수인 diaries의 요소 중 업데이트한 레코드와 id가 일치하는 레코드를 찾아, 
                        // 해당 레코드를 업데이트한 레코드로 변경하기 
                        for (index, diary) in self.diaries.enumerated() {
                            if diary.id == updatedRecord.recordID {
                                self.diaries[index] = Diary(record: updatedRecord)
                            }
                        }
                    }
                    completion(true)
                }
            }
        }
    }
}
```
- 여기서 `fetchDiary()` 를 호출하지 않고,  self.diaries[index]를 활용한 이유도 ‘데이터 추가하기’ 부분에서 설명한 이유와 같습니다. 
```Swift
// 데이터 삭제하기 
func deleteDiary(id: CKRecord.ID, completion: @escaping (Bool) -> Void) {
    CKContainer.default().publicCloudDatabase.delete(withRecordID: id) { deletedRecordId, error  in
        if let error = error {
            print(error)
            completion(false)
        } else {
            completion(true)
        }
    }
}
```
- 데이터를 삭제하는 경우에는 upload 및 update와 달리 CloudKit에 삭제가 반영된 이후에 `fetchDiary()`가 호출되기 때문에, `fetchDiary()`를 사용해도 삭제한 레코드가 화면에서 즉시 사라집니다. 
<br/>

### [CloudKit Console](https://icloud.developer.apple.com/dashboard/home/teams/4QG3GC35LA)
앱의 서버 활동을 보고, 컨테이너를 관리하고, 데이터베이스 스키마를 유지하고, 테스트 데이터를 보고 편집할 수 있는 **직관적인 웹 기반 제어판**입니다.    
CloudKIt Console에서 살펴 볼 수 있는, CloudKit Database의 예시입니다. (해당 프로젝트의 데이터베이스 사진입니다.)

<img width="1440" alt="스크린샷 2022-06-30 오후 4 58 30" src="https://user-images.githubusercontent.com/74223246/176799531-3e100e84-9c5c-4674-967e-76cb77f559b7.png">
