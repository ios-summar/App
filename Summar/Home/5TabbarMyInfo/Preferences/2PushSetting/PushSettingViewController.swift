//
//  PushSettingViewController.swift
//  Summar
//
//  Created by ukBook on 2023/01/14.
//

import Foundation
import UIKit
import SafeAreaBrush

class PushSettingViewController: UIViewController {
    static let shared = PushSettingViewController()
    let pushSettingView = PushSettingView()
    
    let lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "알림설정"
        title.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        // MARK: - fillSafeArea, SafeArea BackGroundColor Set
        fillSafeArea(position: .top, color: .white)
        fillSafeArea(position: .left, color: .white)
        fillSafeArea(position: .right, color: .white)
        fillSafeArea(position: .bottom, color: .white)
        
        // MARK: - NavigationBar
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popScreen), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        // MARK: - addView
        self.view.addSubview(pushSettingView)
        pushSettingView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.left.right.equalTo(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pushSettingView.pushStatus()
    }
    
    @objc func popScreen() {
        self.navigationController?.popViewController(animated: true)
    }
}
