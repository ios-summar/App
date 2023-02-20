//
//  ProfileViewController.swift
//  Summar
//
//  Created by ukBook on 2023/01/21.
//

import Foundation
import UIKit
import SnapKit

final class ProfileViewController : UIViewController, PushDelegate, ViewAttributes{
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        if VC.isKind(of: FollowListTabman.self) {
            let VC = FollowListTabman()
            let param = any as? Dictionary<String, Int>
            VC.userSeq = param!["userSeq"] as! Int
            VC.scrollToIndex = param!["scrollToIndex"] as! Int
            
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: FeedDetailViewController.self) {
            let VC = FeedDetailViewController()
            VC.feedInfo = any as? FeedInfo
            
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: WriteFeedController.self){
            guard let feedInfo = any as? FeedInfo, let feedSeq = feedInfo.feedSeq, let userSeq = feedInfo.user?.userSeq else {return}
            
            helper.showAlertAction(vc: self, message: "신고하기") { handler in
                switch handler {
                case "신고하기":
                    print("신고하기1")
                    let VC = ReportViewController()
                    
                    let param: Dictionary<String, Any> = [
                        "mySeq": getMyUserSeq(),
                        "userSeq": userSeq,
                        "feedSeq": feedSeq,
                        "feedCommentSeq": 0
                    ]
                    
                    VC.param = param
                    self.navigationController?.pushViewController(VC, animated: true)
                default:
                    break
                }
            }
        }
    }
    
    let infoView = MyInfoView()
    let helper = Helper.shared
    
    var userSeq : Int?
    
    var searchUserInfo : SearchUserInfo? {
        didSet {
            guard let searchUserInfo = searchUserInfo else {return}
            userSeq = searchUserInfo.userSeq
        }
    }
    
    override func viewDidLoad() {
        infoView.pushDelegate = self
        
        setUI()
        setAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userSeq = userSeq else {return}
        infoView.requestMyInfo(userSeq)
        infoView.getPortfolio()
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
