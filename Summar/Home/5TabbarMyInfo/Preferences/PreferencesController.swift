//
//  PreferencesController.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import Foundation
import UIKit
import SnapKit

class PreferencesController: UIViewController, PushDelegate, PopDelegate, MyInfoViewDelegate{
    func parameter(_ userInfo: UserInfo?) {
        self.userInfo = userInfo
    }
    
    weak var delegate : PopDelegate?
    
    func popScreen() {
//        self.navigationController?.popViewController(animated: true)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(SocialLoginController.shared, animated: true)
    }
    
    func pushScreen(_ VC: UIViewController) {
        if VC == UpdateMyInfoViewController.shared {
            UpdateMyInfoViewController.shared.userInfo = self.userInfo
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC == PushSettingViewController.shared {
            self.navigationController?.pushViewController(PushSettingViewController.shared, animated: true)
        }
        
    }
    
    static let shared = PreferencesController()
    let preferencesView = PreferencesView()
    
    var userInfo: UserInfo? {
        didSet {
            print("PreferencesController userInfo => \n\(userInfo)")
        }
    }
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.text = "환경 설정"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    let arrowBackWard : UIButton = {
        let arrowBackWard = UIButton()
        arrowBackWard.setImage(UIImage(systemName: "arrow.backward"), for: .normal) // ios 14.0
        arrowBackWard.tintColor = .black
        arrowBackWard.imageView?.contentMode = .scaleToFill
//        xmark.imageEdgeInsets = UIEdgeInsets(top: 32, left: 33, bottom: 33, right: 33)
//        arrowBackWard.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        arrowBackWard.tag = 1
        return arrowBackWard
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferencesView.pushDelegate = self
        preferencesView.popDelegate = self
        preferencesView.myInfoDelegate = self
        self.view.backgroundColor = .white
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        self.view.addSubview(preferencesView)
        
        preferencesView.snp.makeConstraints{(make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        preferencesView.requestMyInfo()
    }
    
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
