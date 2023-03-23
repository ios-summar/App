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
            
            if getMyUserSeq() == userSeq { // 자신 피드
                smLog("자기 피드")
                helper.showAlertAction(vc: self, message1: "수정하기", message2: "삭제하기") { handler in
                    switch handler {
                    case "수정하기":
                        print("게시글 수정 로직")
                        let VC = WriteFeedController()
                        VC.feedInfo = feedInfo
                        
                        LoadingIndicator.showLoading()
                        
                        let wrController = UINavigationController(rootViewController: VC)
                        wrController.navigationBar.isTranslucent = false
                        wrController.navigationBar.backgroundColor = .white
                        wrController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                        self.present(wrController, animated: true, completion: nil)
                    case "삭제하기":
                        self.helper.showAlertActionYN(vc: self, title: "알림", message: "정말로 해당 게시글을 삭제하시겠습니까?") { handler in
                            guard let handler = handler else {
                                return
                            }
                            // 게시글 삭제 로직
                            print("게시글 삭제 로직 feedSeq => \(feedSeq)")
                            self.viewModel.deleteFeed(feedSeq)
                            self.viewModel.didFinishDelteFetch = {
                                self.navigationController?.popViewController(animated: true)
                                toast("삭제됨")
                            }
                        }
                    default:
                        break
                    }
                }
            }else {
                smLog("자기 피드아님")
                helper.showAlertAction(vc: self, message: "신고하기") { handler in
                    switch handler {
                    case "신고하기":
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
    }
    
    let infoView = MyInfoView()
    let helper = Helper.shared
    let viewModel = FeedDetailViewModel()
    
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
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButtonWidth30(self, action: #selector(kebabMenu), uiImage: UIImage(named: "kebabMenu")!, tintColor: .black)
        
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
    
    @objc func kebabMenu() {
        helper.showAlertActionDestructive(vc: self, message1: "신고하기", message2: "차단하기") { handler in
            switch handler {
            case "신고하기":
                guard let userSeq = self.userSeq else {return}
                
                let VC = ReportViewController()
                let param: Dictionary<String, Any> = [
                    "mySeq": getMyUserSeq(),
                    "userSeq": userSeq,
                    "feedSeq": 0,
                    "feedCommentSeq": 0
                ]
                
                VC.param = param
                self.navigationController?.pushViewController(VC, animated: true)
            case "차단하기":
                print("차단하기")
                self.helper.showAlertActionYN(vc: self, title: "알림", message: "정말로 이 사용자를 차단 하시겠습니까?") { handler in
                    guard let handler = handler else {
                        return
                    }
                    
                    if handler {
                        toast("차단됨, 차단 목록은 마이 써머리에서 확인 가능합니다.")
                    }
                }
            default :
                break
            }
        }
    }
}
