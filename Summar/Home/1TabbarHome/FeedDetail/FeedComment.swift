//
//  FeedComment.swift
//  Summar
//
//  Created by plsystems on 2023/02/03.
//

import Foundation

struct FeedComment: Codable{
    let firstPage: Bool?
    let lastPage: Bool?
    let totalPageCount: Int?
    let recordsPerPage: Int?
    let currentPageNo: Int?
    let totalRecordCount: Int?
    let content: [Comment]?
}

struct Comment: Codable{
    let feedCommentSeq: Int?
    let feedSeq: Int?
    let user: Info?
    let activated: Bool?
    let childComments: [Comment]?
    let childCommentsCount: Int?
    let lastMoifiedDate: String?
    let createdDate: String?
    let comment: String?
}
