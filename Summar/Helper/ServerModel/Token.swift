//
//  Token.swift
//  Summar
//
//  Created by mac on 2022/12/23.
//

import Foundation

struct Token : Codable {
    let results: BothToken
}

struct BothToken : Codable {
    let accessToken: String?
    let refreshTokenSeq : String?
}
