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

final class MyInfoViewController : UIViewController, MyInfoViewDelegate, PushDelegate, PopDelegate, ViewAttributes{
    let helper = Helper.shared
    let fontManager = FontManager.shared
    let myInfoView = MyInfoView()
    let feedDetailViewModel = FeedDetailViewModel()
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
            let param = any as? Dictionary<String, Int>
            VC.userSeq = param!["userSeq"] as! Int
            VC.scrollToIndex = param!["scrollToIndex"] as! Int
            
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: FeedDetailViewController.self) {
            let VC = FeedDetailViewController()
            VC.feedInfo = any as? FeedInfo
            
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: WriteFeedController.self){
            guard let feedInfo = any as? FeedInfo, let feedSeq = feedInfo.feedSeq else {return}
            
            helper.showAlertAction(vc: self, message1: "수정하기", message2: "삭제하기") { handler in
                switch handler {
                case "수정하기":
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
                        self.feedDetailViewModel.deleteFeed(feedSeq)
                        self.feedDetailViewModel.didFinishDelteFetch = {
                            
                            self.myInfoView.requestMyInfo(getMyUserSeq())
                            self.myInfoView.getPortfolio()
                            toast("삭제됨")
                        }
                    }
                default:
                    break
                }
            }
        }else {
            let VC = WriteFeedController()
            smLog("\(any as? FeedInfo)")
            VC.feedInfo = any as? FeedInfo

            LoadingIndicator.showLoading()

            let wrController = UINavigationController(rootViewController: VC)
            wrController.navigationBar.isTranslucent = false
            wrController.navigationBar.backgroundColor = .white
            wrController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(wrController, animated: true, completion: nil)
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
    
    lazy var lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "마이 써머리"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        guard let value = UserDefaults.standard.dictionary(forKey: "UserInfo") else {return}
        let userSeq: Int = value["userSeq"] as! Int
        myInfoView.requestMyInfo(userSeq)
        myInfoView.getPortfolio()
        
        // 수정화면에서 넘어올때 hide
        LoadingIndicator.hideLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        myInfoView.touchLeft()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAttributes()
        setDelegate()
        floatingBtn()
    }
    
    func setDelegate() {
        
        myInfoView.delegate = self
        myInfoView.pushDelegate = self
        VC.delegate = self
    }
    
    func setUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPage(_:)), name: NSNotification.Name("showPage"), object: nil)
        
        // MARK: - 마이 써머리 상단 타이틀, 버튼
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(pushViewScreen(_:)), uiImage: UIImage(systemName: "gearshape")!, tintColor: .black)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        // MARK: - addSubView
        self.view.addSubview(myInfoView)
    }
    
    func setAttributes() {
        
        myInfoView.snp.makeConstraints{(make) in

            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
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
    
    @objc func pushViewScreen(_ sender: Any) {
        self.navigationController?.pushViewController(VC, animated: true)
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

