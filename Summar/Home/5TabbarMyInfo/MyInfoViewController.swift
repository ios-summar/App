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
import JJFloatingActionButton

final class MyInfoViewController : UIViewController, MyInfoViewDelegate, PushDelegate, PopDelegate{
    let myInfoView = MyInfoView()
    var window = UIWindow(frame: UIScreen.main.bounds)
    
    let actionButton = JJFloatingActionButton()
    
    func popScreen() {
        print(#file , #function)
    }
    
    let VC = PreferencesController()
    
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        if VC.isKind(of: UpdateMyInfoViewController.self) {
            let VC = UpdateMyInfoViewController()
            VC.userInfo = self.userInfo
            
            print("MyInfoViewController => UpdateMyInfo userInfo\n \(userInfo)")
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: FollowListTabman.self) {
            let VC = FollowListTabman()
            VC.userSeq = any as? Int
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func parameter(_ userInfo: UserInfo?) {
        print(#file , #function)
        self.userInfo = userInfo
    }
    
    // MARK: - Properties
    private var userInfo: UserInfo? {
        didSet {
            print("MyInfoViewController userSeq =>\n\(userInfo?.result.userSeq)")
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
        
        floatingBtn()
    }
    
    func floatingBtn(){
        actionButton.addItem(title: "피드 작성하기", image: UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)) { item in
            
            let wrController = UINavigationController(rootViewController:  WriteFeedController())
            wrController.navigationBar.isTranslucent = false
            wrController.navigationBar.backgroundColor = .white
            wrController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(wrController, animated: true, completion: nil)
        }

        
        self.view.addSubview(actionButton)
        
        actionButton.snp.makeConstraints{(make) in
            make.width.height.equalTo(56)
            make.bottom.right.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        actionButton.buttonColor = .systemBlue
        actionButton.configureDefaultItem { item in
            item.buttonColor = .white
            item.buttonImageColor = .systemBlue

            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0.4)
            item.layer.shadowRadius = CGFloat(2)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let value = UserDefaults.standard.dictionary(forKey: "UserInfo") else {return}
        let userSeq: Int = value["userSeq"] as! Int
        myInfoView.requestMyInfo(userSeq)
        myInfoView.getPortfolio(userSeq)
        LoadingIndicator.hideLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        myInfoView.touchLeft()
    }
    
    @objc func pushViewScreen(_ sender: Any) {
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

