//
//  Notice.swift
//  Summar
//
//  Created by ukBook on 2023/01/15.
//

import Foundation

struct Notice: Codable {
    let status: String?
    let message: String?
    let errorMessage: String?
    let errorCode: String?
    let result: NoticeResult?
}

struct NoticeResult: Codable {
    let results: [NoticeResults]?
}

struct NoticeResults: Codable {
    let content: String?
    let regDatetime : String?
    let settingId : Int?
    let settingType : String?
    let title : String?
}
