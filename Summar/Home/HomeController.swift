//
//  HomeController.swift
//  Summar
//
//  Created by mac on 2022/11/02.
//

import Foundation
import UIKit
import JJFloatingActionButton

class HomeController : UITabBarController {
    static let shared = HomeController()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.BackgroundColor
        fillSafeArea(position: .top, color: .white)
        fillSafeArea(position: .left, color: .white)
        fillSafeArea(position: .right, color: .white)
        fillSafeArea(position: .bottom, color: .white)
        
        UITabBar.appearance().barTintColor = UIColor.summarColor1
//        UITabBar.appearance().backgroundColor = UIColor.white
        
        let appearanceTabbar = UITabBarAppearance()
        appearanceTabbar.configureWithOpaqueBackground()
        appearanceTabbar.backgroundColor = UIColor.white
        tabBar.standardAppearance = appearanceTabbar
        
        // tabBar Custom
//        tabBar.layer.cornerRadius = tabBar.frame.height * 0.41
//        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.tintColor = .black
        
        setupVCs()
//        addMiddleButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            print("UserInfo => ", value)
        }else {
            print("userInfo nil")
        }
    }
    
    // MARK: - UIBar Create NavigtaionController
    func setupVCs() {
          viewControllers = [
            createNavController(for: HomeViewController.shared, title: NSLocalizedString("홈", comment: ""), image: UIImage(named: "home")!, selectedImage: UIImage(named: "sHome")!),
            createNavController(for: ClippingViewController.shared, title: NSLocalizedString("스크랩보기", comment: ""), image: UIImage(named: "scrab")!, selectedImage: UIImage(named: "sScrab")!),
//            createNavController(for: WriteFeedController.shared, title: NSLocalizedString("", comment: ""), image: UIImage(named: "write")!, selectedImage: UIImage(named: "sWrite")!),
            createNavController(for: SearchViewController.shared, title: NSLocalizedString("검색", comment: ""), image: UIImage(named: "search")!, selectedImage: UIImage(named: "sSearch")!),
            createNavController(for: MyInfoViewController.shared, title: NSLocalizedString("마이 써머리", comment: ""), image: UIImage(named: "myInfo")!, selectedImage: UIImage(named: "sMyInfo")!)
          ]
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
    
//    func addMiddleButton() {
//        // DISABLE TABBAR ITEM - behind the "+" custom button:
//        DispatchQueue.main.async {
//            if let items = self.tabBar.items {
//                 items[2].isEnabled = false
//            }
//        }
//
//        // shape, position and size
//        tabBar.addSubview(middleButton)
//        let size = CGFloat(50)
//
//        middleButton.snp.makeConstraints{(make) in
//            make.centerX.equalTo(tabBar.snp.centerX)
//            make.top.equalTo(tabBar.snp.top).offset(-20)
//            make.width.height.equalTo(size)
//        }
//
//        middleButton.layer.cornerRadius = 15
//
//        // other
//        middleButton.layer.masksToBounds = false
//        middleButton.translatesAutoresizingMaskIntoConstraints = false
//
//        // action
//        middleButton.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
//
//    }
    
//    @objc func buttonHandler(){
//        let wrController = UINavigationController(rootViewController:  WriteFeedController.shared)
//        wrController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        self.present(wrController, animated: true, completion: nil)
//    }
    
}


