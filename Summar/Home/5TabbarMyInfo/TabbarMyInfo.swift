//
//  TabbarMyInfo.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

class TabbarMyInfo : UIViewController {
    static let shared = TabbarMyInfo()
    
    let titleViewMyInfo = TitleViewMyInfo.shared
    let myInfoView = MyInfoView.shared
    
    let label : UILabel = {
        let label = UILabel()
        label.text = "마이 써머리"
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(titleViewMyInfo)
        self.view.addSubview(myInfoView)
        
        // MARK: - 마이 써머리 상단 타이틀, 버튼 
        titleViewMyInfo.snp.makeConstraints{(make) in
            
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        myInfoView.snp.makeConstraints{(make) in

            make.topMargin.equalTo(self.titleViewMyInfo.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myInfoView.requestMyInfo()
        print(#file , #function)
    }
}

