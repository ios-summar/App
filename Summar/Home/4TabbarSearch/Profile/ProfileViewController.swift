//
//  ProfileViewController.swift
//  Summar
//
//  Created by ukBook on 2023/01/21.
//

import Foundation
import UIKit
import SnapKit

final class ProfileViewController : UIViewController, ViewAttributes{
    static let shared = ProfileViewController()
    let infoView = MyInfoView()
    let helper = Helper()
    
    var userSeq : Int?
    
    var searchUserInfo : SearchUserInfo? {
        didSet {
            guard let searchUserInfo = searchUserInfo else {return}
            userSeq = searchUserInfo.userSeq
        }
    }
    let titleLabel : UILabel = {
        let title = UILabel()
        title.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        setUI()
        setAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userSeq = userSeq else {return}
        infoView.requestMyInfo(userSeq)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            guard let userSeq = value["userSeq"], let opponentUserSeq = self.userSeq else {return}
            let myUserSeq: Int = userSeq as! Int
            
            // 내 피드일 때
            if myUserSeq == opponentUserSeq {
                infoView.touchLeft()
            }
        }
    }
    
    func setUI() {
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popView), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        self.view.addSubview(infoView)
    }
    
    func setAttributes() {
        infoView.snp.makeConstraints{
            $0.right.left.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}
