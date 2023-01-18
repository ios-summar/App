//
//  FeedSelectResponse.swift
//  Summar
//
//  Created by ukBook on 2023/01/18.
//

import Foundation

struct FeedSelectResponse: Codable {
    let firstPage: Bool?
    let lastPage: Bool?
    let totalPageCount: Int?
    let recordsPerPage: Int?
    let currentPageNo: Int?
    let totalRecordCount: Int?
    let content: [FeedInfo]?
}

struct FeedInfo: Codable {
    let feedSeq : Int?
    let userSeq : Int?
    let contents : String?
    let feedImages : [FeedImages]
}
