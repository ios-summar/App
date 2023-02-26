//
//  TabbarHomeController.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit
import JJFloatingActionButton

final class HomeViewController : UIViewController, HomeViewDelegate, ViewAttributes {
//    func scrollBarInterAction(_ handler: Bool) {
//        DispatchQueue.main.async {
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
//                self.navigationController?.setNavigationBarHidden(handler, animated: true)
//            }, completion: nil)
//        }
//    }
    
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
    
    let homeView = HomeView()
    let actionButton = JJFloatingActionButton()
    
    let viewWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth
    }()
    
    let titleImageView : UIImageView = {
        let title = UIImageView()
        title.image = UIImage(named: "Title")
        return title
    }()
    
    let directBtn : UIButton = {
        let directBtn = UIButton()
        directBtn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        directBtn.tintColor = .black
        directBtn.imageView?.contentMode = .scaleToFill
        directBtn.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 33, right: 35)
//        directBtn.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        directBtn.tag = 2
        return directBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setUI()
        setAttributes()
        floatingBtn()
    }
    
    func setDelegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPage(_:)), name: NSNotification.Name("showPage"), object: nil)
        homeView.homeViewDelegate = self
//        homeView.delegate = self
    }
    
    func setUI() {
        
        // MARK: - NavigationBar
        let lbNavTitle = UIView (frame: CGRect(x: 0, y: 0, width: viewWidth, height: 40))
        lbNavTitle.layer.borderWidth = 1
        lbNavTitle.addSubview(titleImageView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lbNavTitle)
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "bell.fill")!, tintColor: .black)
        // MARK: - addView
        
        self.view.addSubview(homeView)
    }
    
    func setAttributes() {
        
        titleImageView.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalTo(72)
            make.height.equalTo(18)
        }
        
        homeView.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeView.selectFeed()
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
    
    @objc func topBtnAction(_ sender: Any){
        let VC = NotificationViewController()
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

