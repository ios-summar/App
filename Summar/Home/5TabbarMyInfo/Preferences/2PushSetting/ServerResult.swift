//
//  ServerResult.swift
//  Summar
//
//  Created by ukBook on 2023/01/14.
//

import Foundation

struct ServerResult: Codable {
    let status: String?
    let message: String?
    let errorMessage: String?
    let errorCode: String?
    let result: Bool?
}
