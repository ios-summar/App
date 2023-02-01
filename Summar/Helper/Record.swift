//
//  Record.swift
//  Summar
//
//  Created by plsystems on 2023/01/20.
//

import Foundation
import UIKit

final class Record {
    /// 폰트 체크 하기
    func fontCheck() {
        UIFont.familyNames.sorted().forEach { familyName in
            print("*** \(familyName) ***")
            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print("\(fontName)")
            }
            print("---------------------")
        }
    }
    
}
