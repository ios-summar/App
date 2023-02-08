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
    let user : Info?
    let contents : String?
    let feedImages : [FeedImages]
    let secretYn: Bool?
    let commentYn: Bool?
    let tempSaveYn: Bool?
    let likeYn: Bool?
    let totalLikeCount: Int?
    let scrapYn: Bool?
    let totalCommentCount: Int?
    let activated: Bool?
    let lastModifiedDate: String?
    let createdDate: String?
}
