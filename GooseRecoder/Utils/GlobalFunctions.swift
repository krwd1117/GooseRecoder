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
