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
    let myInfoView = MyInfoView()
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

            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let value = UserDefaults.standard.dictionary(forKey: "UserInfo") else {return}
        let userSeq: Int = value["userSeq"] as! Int
        myInfoView.requestMyInfo(userSeq)
        LoadingIndicator.hideLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        myInfoView.touchLeft()
    }
    
    @objc func pushViewScreen(_ sender: Any) {
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

