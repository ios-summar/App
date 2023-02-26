//
//  TabbarClipping.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

final class ClippingViewController : UIViewController, ViewAttributes, HomeViewDelegate{
    let fontManager = FontManager.shared
    
    func pushScreen(_ VC: UIViewController, _ any: Any) {
        if VC.isKind(of: FeedDetailViewController.self) {
            let VC = FeedDetailViewController()
            
            VC.feedInfo = any as? FeedInfo
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: ProfileViewController.self) {
            let VC = ProfileViewController()
            
            VC.userSeq = any as? Int
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    let clippingView = ClippingView()
    lazy var lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "스크랩보기"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clippingView.delegate = self
        
        setDelegate()
        setUI()
        setAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clippingView.selectFeed()
    }
    
    func setDelegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPage(_:)), name: NSNotification.Name("showPage"), object: nil)
    }
    
    func setUI(){
        // MARK: - 마이 써머리 상단 타이틀, 버튼
        self.navigationItem.titleView = lbNavTitle
        self.view.addSubview(clippingView)
    }
    
    func setAttributes() {
        clippingView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func showPage(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            guard let pushType = userInfo["pushType"] as? String else {toast("화면이동 오류, 잠시후 다시 시도해주세요."); return}
            
            switch pushType {
            case "댓글", "대댓글":
                guard let feedInfo = userInfo["feedInfo"] as? FeedInfo, let feedCommentSeq = userInfo["feedCommentSeq"] as? Int else {toast("화면이동 오류, 잠시후 다시 시도해주세요."); return}
                
                let VC = FeedDetailViewController()
                
                VC.feedInfo = feedInfo
                VC.feedCommentSeq = feedCommentSeq
                self.navigationController?.pushViewController(VC, animated: true)
                
            case "좋아요", "팔로우":
                guard let userSeq = userInfo["userSeq"] as? Int else {toast("화면이동 오류, 잠시후 다시 시도해주세요."); return}
                
                
                let VC = ProfileViewController()
                VC.userSeq = userSeq
                
                self.navigationController?.pushViewController(VC, animated: true)
                
            default:
                break
            }
        }
    }
}

