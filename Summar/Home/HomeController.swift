//
//  HomeController.swift
//  Summar
//
//  Created by mac on 2022/11/02.
//

import Foundation
import UIKit

final class HomeController : UITabBarController, ViewAttributes {
    let feedDetailViewModel = FeedDetailViewModel()
    let helper = Helper()
    var param: [String: Any]?
    
    lazy var middleButton: UIButton! = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotificationCenter()
        setUI()
        setAttributes()
    }
    
    func setNotificationCenter() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            guard let param = self.param else {return}
            self.showPageProceessPushNotRunning(param)
        }
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
    
    func showPageProceessPushNotRunning(_ userInfo: [String: Any]) {
        let pushType = userInfo["pushType"] as? String
        
        switch pushType {
        case "댓글", "대댓글" :
            guard let feedSeq = Int(String(describing: userInfo["feedSeq"] ?? "0")) else {return}
            feedDetailViewModel.getFeedInfo(feedSeq)
            feedDetailViewModel.didFinishFetch = {
                
                NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: [
                    "pushType" : pushType,
                    "feedInfo" : self.feedDetailViewModel.feedInfo,
                    "feedCommentSeq" : Int(String(describing: userInfo["feedCommentSeq"] ?? "0"))
                ])
            }
            
        case "좋아요", "팔로우" :
            NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: [
                "pushType" : pushType,
                "userSeq" : Int(String(describing: userInfo["userSeq"] ?? "0"))
            ])
            
        default:
            break
        }
    }
}


