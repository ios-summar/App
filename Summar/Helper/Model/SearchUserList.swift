//
//  SearchUserList.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import Foundation

struct SearchUserList: Codable {
    let firstPage: Bool?
    let lastPage: Bool?
    let totalPageCount: Int?
    let recordsPerPage: Int?
    let currentPageNo: Int?
    let totalRecordCount: Int?
    let content: [SearchUserInfo]?
}

struct SearchUserInfo: Codable {
    let userNickname: String?
    let major1: String?
    let major2: String?
    let follower: Int?
    let following: Int?
    let introduce: String?
    let profileImageUrl: String?
}

