//
//  UserDefaultHelper.swift
//  Summar
//
//  Created by ukBook on 2023/02/07.
//

import Foundation

internal func getMyUserSeq() -> Int {
    if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
        guard let userSeq = value["userSeq"] as? Int else { return 0 }
        
        return userSeq
    }else {
        return 0
    }
}
