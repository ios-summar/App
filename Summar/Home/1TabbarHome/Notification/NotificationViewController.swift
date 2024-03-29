//
//  NotificationViewController.swift
//  Summar
//
//  Created by ukBook on 2023/02/19.
//

import Foundation
import UIKit

final class NotificationViewController: UIViewController, ViewAttributes, PushDelegate {
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        if VC.isKind(of: ProfileViewController.self){
            guard let userSeq = any as? Int else{toast("화면이동 오류, 잠시후 다시 시도해주세요."); return}
            let VC = ProfileViewController()
            
            VC.userSeq = userSeq
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: FeedDetailViewController.self){
            guard let param = any as? Dictionary<String, Any> else{toast("화면이동 오류, 잠시후 다시 시도해주세요."); return}
            let VC = FeedDetailViewController()
            
            VC.feedInfo = param["feedInfo"] as? FeedInfo
            VC.feedCommentSeq = param["feedCommentSeq"] as? Int
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    let notificationView = NotificationView()
    let fontManager = FontManager.shared
    
    lazy var lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "알림"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notificationView.getNotiList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setUI()
        setAttributes()
    }
    
    func setDelegate() {
        
        notificationView.delegate = self
    }
    
    func setUI() {
        
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popView), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        self.view.addSubview(notificationView)
    }
    
    func setAttributes() {
        
        notificationView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func popView() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
