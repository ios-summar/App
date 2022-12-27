//
//  TabbarSearch.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

class TabbarSearch : UIViewController {
    static let shared = TabbarSearch()
    let titleView = TitleViewSearch.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleView)
        
        titleView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}

