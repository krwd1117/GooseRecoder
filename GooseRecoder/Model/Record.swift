//
//  RecordI.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import RealmSwift

class Record: Object {
    
    @objc dynamic var uuidString = UUID().uuidString
    @objc dynamic var address = ""
    @objc dynamic var date = ""
    @objc dynamic var time = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var memo = ""
    
    override class func primaryKey() -> String? {
        return "uuidString"
    }
    
}
