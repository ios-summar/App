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
    
    let titleView = TitleViewHome.shared
    let homeView = HomeView.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleView)
        self.view.addSubview(homeView)
        titleView.backgroundColor = UIColor.BackgroundColor
        
        titleView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        homeView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(self.titleView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

