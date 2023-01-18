//
//  FeedInsertResponse.swift
//  Summar
//
//  Created by ukBook on 2023/01/18.
//

import Foundation

struct FeedInsertResponse: Codable {
    let result : FeedInsert
}

struct FeedInsert: Codable {
    let feedSeq : Int?
    let userSeq : Int?
    let contents : String?
    let feedImages : [FeedImages]
    let secretYn : Bool?
    let commentYn : Bool?
    let tempSaveYn : Bool?
}

struct FeedImages: Codable {
    let feedImageSeq: Int?
    let feedSeq: Int?
    let imageUrl: String?
    let orderNo: Int?
}

