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
    
    let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleView)
        self.view.addSubview(scrollView)
        titleView.layer.borderColor = UIColor.white.cgColor
        titleView.layer.borderWidth = 5
        titleView.backgroundColor = .white
        self.view.backgroundColor = .grayColor197
        
        titleView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.leftMargin.equalTo(0)
            make.rightMargin.equalTo(0)
            make.height.equalTo(40)
        }
        
        scrollView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(titleView.snp.bottom)
            make.leftMargin.equalTo(0)
            make.rightMargin.equalTo(0)
            make.height.equalTo(500)
        }
    }
}

