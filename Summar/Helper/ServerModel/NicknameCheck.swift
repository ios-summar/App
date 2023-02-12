//
//  NicknameCheck.swift
//  Summar
//
//  Created by mac on 2023/01/06.
//

import Foundation

struct NicknameCheck: Codable {
    let status: String?
    let message: String?
    let errorMessage: String?
    let errorCode: Int?
    let result: NicknameCheckResult?
}

struct NicknameCheckResult: Codable {
    let result: Bool?
}
