//
//  TabbarHomeController.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

class TabbarHomeController : UIViewController {
    static let shared = TabbarHomeController()
    
    let titleView = TitleView.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleView)
        titleView.layer.borderColor = UIColor.blue.cgColor
        titleView.layer.borderWidth = 5
        titleView.backgroundColor = .grayColor197
        self.view.backgroundColor = .magenta
        
        titleView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.leftMargin.equalTo(0)
            make.rightMargin.equalTo(0)
            make.height.equalTo(50)
        }
    }
}

