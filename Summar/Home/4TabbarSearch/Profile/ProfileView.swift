//
//  ProfileView.swift
//  Summar
//
//  Created by ukBook on 2023/01/21.
//

import Foundation
import UIKit
import SnapKit

final class ProfileView: UIView {
    let helper = Helper.shared
    
    var searchUserInfo : SearchUserInfo? {
        didSet {
            smLog("\n \(searchUserInfo) \n")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
