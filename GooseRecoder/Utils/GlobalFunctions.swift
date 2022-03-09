//
//  GlobalFunctions.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/06.
//

import Foundation

func getDate(date: Date) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "ko_KR")
    df.dateFormat = "yyyy-MM-dd"
    return df.string(from: date)
}

func getTime(date: Date) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "ko_KR")
    df.dateFormat = "HH:mm:ss"
    return df.string(from: date)
}

func getDiveceIdentifier() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    return identifier
    
}
