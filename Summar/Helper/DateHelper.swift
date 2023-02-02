//
//  DateHelper.swift
//  Summar
//
//  Created by plsystems on 2023/02/02.
//

import Foundation

internal func compareDate(_ dbDate: String?) -> String {
//    2023-02-03T04:05:06
    guard let dbDate = dbDate else { return "" }
//    print("dbDate \(dbDate)")
    let year : Int = Int(dbDate.substring(from: 0, to: 3))!
    let month = Int(dbDate.substring(from: 5, to: 6))!
    let day = Int(dbDate.substring(from: 8, to: 9))!
    let hour = Int(dbDate.substring(from: 11, to: 12))!
    let minute = Int(dbDate.substring(from: 14, to: 15))!
    
    let myDateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    let startDate = Calendar.current.date(from: myDateComponents)!
    
    let offsetComps = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: startDate, to: Date())
    
    if case let (y?, m?, d?, h?, M?) = (offsetComps.year, offsetComps.month, offsetComps.day, offsetComps.hour, offsetComps.minute) {
//      print("\(y)년 \(m)월 \(d)일 \(h)시간 \(M)분 만큼 차이남")
        if y >= 1 {
            return "\(y)년 전"
        }else if m >= 1 {
            return "\(m)개월 전"
        }else if d >= 1 {
            return "\(d)일 전"
        }else if h >= 1 {
            return "\(h)시간 전"
        }else if M >= 5{
            return "\(M)분 전"
        }else {
            return "방금 전"
        }
    }
    return ""
}
