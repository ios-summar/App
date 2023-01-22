//
//  FeedDetailView.swift
//  Summar
//
//  Created by ukBook on 2023/01/22.
//

import Foundation
import UIKit

class FeedDetailVeiw: UIView {
    static let shared = FeedDetailVeiw()
    let helper = Helper.shared
    
    var feedInfo : FeedInfo? {
        didSet {
            smLog("feedInfo")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
