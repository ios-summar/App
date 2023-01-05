//
//  TabbarMyInfo.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

class TabbarMyInfo : UIViewController{
    static let shared = TabbarMyInfo()
    
//    let titleViewMyInfo = TitleViewMyInfo.shared
    let myInfoView = MyInfoView.shared
    
    let lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "마이 써머리"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    let gear : UIBarButtonItem = {
        let gear = UIBarButtonItem()
        gear.image = UIImage(systemName: "gearshape")
//        gear.setImage(UIImage(systemName: "gearshape"), for: .normal) // ios 14.0
        gear.tintColor = .black
//        gear.imageView?.contentMode = .scaleToFill
//        gear.imageEdgeInsets = UIEdgeInsets(top: 32, left: 33, bottom: 33, right: 33)
//        gear.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        gear.tag = 1
        return gear
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(titleViewMyInfo)
        self.view.addSubview(myInfoView)
        
//        titleViewMyInfo.delegate = self
        
        // MARK: - 마이 써머리 상단 타이틀, 버튼
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(pushScreen), uiImage: UIImage(systemName: "gearshape")!, tintColor: .black)
        
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
         
//        titleViewMyInfo.snp.makeConstraints{(make) in
//
//            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.height.equalTo(60)
//        }
        
        myInfoView.snp.makeConstraints{(make) in

            make.topMargin.equalTo(0)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myInfoView.requestMyInfo()
        print(#file , #function)
    }
    
    @objc func pushScreen() {
        self.navigationController?.pushViewController(PreferencesController(), animated: true)
    }
}

