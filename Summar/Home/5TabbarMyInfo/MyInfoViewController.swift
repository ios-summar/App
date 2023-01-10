//
//  MyInfoViewController.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

class MyInfoViewController : UIViewController{
    static let shared = MyInfoViewController()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(myInfoView)
        
        // MARK: - 마이 써머리 상단 타이틀, 버튼
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(pushScreen), uiImage: UIImage(systemName: "gearshape")!, tintColor: .black)
        
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
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

