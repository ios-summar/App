//
//  HomeController.swift
//  Summar
//
//  Created by mac on 2022/11/02.
//

import Foundation
import UIKit

final class HomeController : UITabBarController, ViewAttributes {
    var layerHeight = CGFloat()
    public lazy var middleButton: UIButton! = {
        let middleButton = UIButton()
        
        middleButton.frame.size = CGSize(width: 48, height: 48)
        
        let image = UIImage(systemName: "plus")!
        middleButton.setImage(image, for: .normal)
        middleButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        middleButton.backgroundColor = .systemBlue
        middleButton.tintColor = .white
        middleButton.layer.cornerRadius = 8
        
        return middleButton
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            print("UserInfo => ", value)
        }else {
            print("userInfo nil")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setUI()
        setAttributes()
        
    }
    
    func setDelegate() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPage(_:)), name: NSNotification.Name("showPage"), object: nil)
    }
    
    func setUI() {
        
        // MARK: - UIBar Create NavigtaionController
        viewControllers = [
          createNavController(for: HomeViewController(), title: NSLocalizedString("홈", comment: ""), image: UIImage(named: "home")!, selectedImage: UIImage(named: "sHome")!),
          createNavController(for: ClippingViewController(), title: NSLocalizedString("스크랩", comment: ""), image: UIImage(named: "scrap")!, selectedImage: UIImage(named: "sScrap")!),
          createNavController(for: SearchViewController(), title: NSLocalizedString("검색", comment: ""), image: UIImage(named: "search")!, selectedImage: UIImage(named: "sSearch")!),
          createNavController(for: MyInfoViewController(), title: NSLocalizedString("마이 써머리", comment: ""), image: UIImage(named: "myInfo")!, selectedImage: UIImage(named: "sMyInfo")!)
        ]
  }
    
    func setAttributes() {
        
        self.view.backgroundColor = UIColor.BackgroundColor
        fillSafeArea(position: .top, color: .white)
        fillSafeArea(position: .left, color: .white)
        fillSafeArea(position: .right, color: .white)
        fillSafeArea(position: .bottom, color: .white)
        
        UITabBar.appearance().barTintColor = UIColor.summarColor1
        
        let appearanceTabbar = UITabBarAppearance()
        appearanceTabbar.configureWithOpaqueBackground()
        appearanceTabbar.backgroundColor = UIColor.white
        tabBar.standardAppearance = appearanceTabbar
        tabBar.tintColor = .black
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String?, image: UIImage, selectedImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController:  rootViewController)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        navController.interactivePopGestureRecognizer?.delegate = nil // 스와이프 제스처 enable true
        return navController
    }
    
    @objc func showPage(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            guard let pushType = userInfo["pushType"] as? String else {toast("화면이동 오류, 잠시후 다시 시도해주세요."); return}
            
            switch pushType {
            case "댓글", "대댓글":
                guard let feedInfo = userInfo["feedInfo"] as? FeedInfo else {toast("화면이동 오류, 잠시후 다시 시도해주세요."); return}
                
                let VC = FeedDetailViewController()
                
                VC.feedInfo = feedInfo
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


