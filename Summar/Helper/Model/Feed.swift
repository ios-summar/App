//
//  Feed.swift
//  Summar
//
//  Created by mac on 2022/12/21.
//

import Foundation

struct Feed : Codable {
    let feedSeq: Int?
    let createBy: String?
    let createDate: Date?
    let lastModifiedBy: String?
    let modifiedDate: String?
    let activated: Bool?
    let contents: String?
    let userSeq: Int?
    
    enum CodingKeys: String, CodingKey {
        case feedSeq = "feed_seq"
        case createBy = "create_by"
        case createDate = "create_date"
        case lastModifiedBy = "last_modified_by"
        case modifiedDate = "modified_date"
        case activated = "activated"
        case contents = "contents"
        case userSeq = "user_seq"
    }
    
    init(feedSeq: Int? = 1, createBy: String? = "createBy", createDate: Date? = nil, lastModifiedBy: String? = "lastModifiedBy", modifiedDate: String? = "modifiedDate", activated: Bool? = true, contents: String? = "contentscontents", userSeq: Int? = 1) {
        let date = Date()
        
        self.feedSeq = feedSeq
        self.createBy = createBy
        self.createDate = date
        self.lastModifiedBy = lastModifiedBy
        self.modifiedDate = modifiedDate
        self.activated = activated
        self.contents = contents
        self.userSeq = userSeq
    }
}
