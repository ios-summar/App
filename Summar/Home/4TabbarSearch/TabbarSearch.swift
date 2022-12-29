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
    let searchView = SearchView.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(searchView)
        
        searchView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

