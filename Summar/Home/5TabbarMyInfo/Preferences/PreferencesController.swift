//
//  PreferencesController.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import Foundation
import UIKit
import SnapKit

final class PreferencesController: UIViewController, PushDelegate, PopDelegate, MyInfoViewDelegate{
    let fontManager = FontManager.shared
    func parameter(_ userInfo: UserInfo?) {
        self.userInfo = userInfo
    }
    
    weak var delegate : PopDelegate?
    
    func popScreen() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(SocialLoginController(), animated: true)
    }
    
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        if VC.isKind(of: UpdateMyInfoViewController.self) {
            let VC = UpdateMyInfoViewController()
            VC.userInfo = self.userInfo
            
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: PushSettingViewController.self) {
            let VC = PushSettingViewController()
            
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: NoticeController.self) {
            let VC = NoticeController()
            
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: FAQController.self) {
            let VC = FAQController()
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    let preferencesView = PreferencesView()
    
    var userInfo: UserInfo? {
        didSet {
            print("PreferencesController userInfo => \n\(userInfo)")
        }
    }
    
    lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "설정"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    let arrowBackWard : UIButton = {
        let arrowBackWard = UIButton()
        arrowBackWard.setImage(UIImage(systemName: "arrow.backward"), for: .normal) // ios 14.0
        arrowBackWard.tintColor = .black
        arrowBackWard.imageView?.contentMode = .scaleToFill
        arrowBackWard.tag = 1
        return arrowBackWard
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferencesView.pushDelegate = self
        preferencesView.popDelegate = self
        preferencesView.myInfoDelegate = self
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
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
        LoadingIndicator.hideLoading()
    }
    
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
