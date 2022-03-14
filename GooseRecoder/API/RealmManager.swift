//
//  RealmManager.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/13.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {
    
    static let shared = RealmManager()
    
    var records: Results<Record>!
    let realm = try! Realm()
 
}

// MARK: - Record
extension RealmManager {
    // 기록 개수 세기
    func countRecords() -> Int {
        return records.count
    }
    
    // 기록 삭제
    func deleteRecord(uuidString: String) {
        do {
            try realm.write({
                let predicate = NSPredicate(format: "uuidString = %@", uuidString)
                realm.delete(realm.objects(Record.self).filter(predicate))
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 기록 불러오기
    func loadRecords(_ selectedDate: String) {
        let predicate = NSPredicate(format: "date = %@", selectedDate)
        records = realm.objects(Record.self).filter(predicate).sorted(byKeyPath: "time", ascending: true)
    }
    
    // 기록 모두 지우기
    func clearAllRecords(_ selectedDate: String) {
        do{
            try realm.write({
                let predicate = NSPredicate(format: "date = %@", selectedDate)
                realm.delete(realm.objects(Record.self).filter(predicate))
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 기록 추가
    func appendRecord(latitude: Double, longitude: Double, address: String) {
        let recordItem = Record()
        recordItem.address = address
        recordItem.date = getDate(date: Date())
        recordItem.time = getTime(date: Date())
        recordItem.latitude = latitude
        recordItem.longitude = longitude
        
        try! self.realm.write {
            self.realm.add(recordItem)
        }
    }
    
    func updateMemo(recordItem: RecordItem, text: String) {
        let predicate = NSPredicate(format: "uuidString = %@", recordItem.uuidString)
        let record = realm.objects(Record.self).filter(predicate)
            do {
                try realm.write {
                    record[0].memo = text
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
    }
    
}

