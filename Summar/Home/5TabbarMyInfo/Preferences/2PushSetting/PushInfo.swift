//
//  PushInfo.swift
//  Summar
//
//  Created by ukBook on 2023/01/14.
//

import Foundation

struct PushInfo: Codable {
    let result: status
}

struct status: Codable {
    let status: Bool?
}
