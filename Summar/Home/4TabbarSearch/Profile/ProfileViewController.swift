//
//  ProfileViewController.swift
//  Summar
//
//  Created by ukBook on 2023/01/21.
//

import Foundation
import UIKit
import SnapKit

class ProfileViewController : UIViewController{
    static let shared = ProfileViewController()
    let profileView = ProfileView()
    let helper = Helper()
    
    var searchUserInfo : SearchUserInfo? {
        didSet {
            guard let searchUserInfo = searchUserInfo else {return}
            
            profileView.searchUserInfo = searchUserInfo // UIView에 인자 전달
            titleLabel.text = searchUserInfo.userNickname // 네비바 타이틀을 닉네임으로 set
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
        configureUI()
    }
    
    /// UI 초기설정
    func configureUI() {
        // MARK: - SafeArea or View BackGroundColor Set
        
        // MARK: - NavigationBar
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popView), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        // MARK: - addView
        self.view.addSubview(profileView)
        profileView.snp.makeConstraints{
            $0.right.left.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}
