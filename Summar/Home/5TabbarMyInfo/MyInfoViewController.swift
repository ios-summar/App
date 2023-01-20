//
//  MyInfoViewController.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class MyInfoViewController : UIViewController, MyInfoViewDelegate, PushDelegate, PopDelegate{
    var window = UIWindow(frame: UIScreen.main.bounds)
    
    func popScreen() {
        print(#file , #function)
    }
    
    let VC = PreferencesController.shared
    
    func pushScreen(_ VC: UIViewController) {
        if VC == UpdateMyInfoViewController.shared {
            UpdateMyInfoViewController.shared.userInfo = self.userInfo
            print("MyInfoViewController => UpdateMyInfo userInfo\n \(userInfo)")
            self.navigationController?.pushViewController(UpdateMyInfoViewController.shared, animated: true)
        }
    }
    
    func parameter(_ userInfo: UserInfo?) {
        print(#file , #function)
        self.userInfo = userInfo
    }
    
    static let shared = MyInfoViewController()
    let myInfoView = MyInfoView.shared
    
    // MARK: - Properties
    private var userInfo: UserInfo? {
        didSet {
//            print("MyInfoViewController userInfo =>\n\(userInfo)")
        }
    }
    
    let lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "마이 써머리"
        title.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(myInfoView)
        myInfoView.delegate = self
        myInfoView.pushDelegate = self
        VC.delegate = self
        
        // MARK: - 마이 써머리 상단 타이틀, 버튼
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(pushViewScreen(_:)), uiImage: UIImage(systemName: "gearshape")!, tintColor: .black)
        
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        myInfoView.snp.makeConstraints{(make) in

            make.topMargin.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
//            print("UserInfo => ", value)
            print("UserInfo userSeq => ", value["userSeq"])
            myInfoView.requestMyInfo()
            myInfoView.requestMyFeed(value["userSeq"] as? Int ?? nil)
            LoadingIndicator.hideLoading()
        }else {
            print("userInfo nil")
        }
    }
    
    @objc func pushViewScreen(_ sender: Any) {
//        guard let userInfo = userInfo else {return}
//
//        VC.userInfo = userInfo
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

