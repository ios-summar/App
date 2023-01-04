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
    
    let viewWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleView)
        self.view.addSubview(homeView)
        titleView.backgroundColor = UIColor.BackgroundColor
        titleView.layer.borderWidth = 1
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: viewWidth, height: 40))
        lbNavTitle.layer.borderWidth = 1
        lbNavTitle.textColor = UIColor.black
        lbNavTitle.numberOfLines = 0
        lbNavTitle.center = CGPoint(x: 0, y: 0)
        lbNavTitle.textAlignment = .left
    //        lbNavTitle.font = UIFont(name: "나눔손글씨 암스테르담", size: 24)
        lbNavTitle.text = "기프티콘 저장"
        self.navigationItem.titleView = lbNavTitle
        
        
        titleView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        homeView.snp.makeConstraints{(make) in
//            make.topMargin.equalTo(self.titleView.snp.bottom)
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(0)
        }
        
    }
}

