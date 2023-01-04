//
//  HomeController.swift
//  Summar
//
//  Created by mac on 2022/11/02.
//

import Foundation
import UIKit

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
        
//        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
//
//        self.addSubview(middleButton)
        
        return middleButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.BackgroundColor
        
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            print("UserInfo => ", value)
        }else {
            print("userInfo nil")
        }
        
        UITabBar.appearance().barTintColor = UIColor.summarColor1
        UITabBar.appearance().backgroundColor = UIColor.UIBarColor
        
        // tabBar Custom
        tabBar.layer.cornerRadius = tabBar.frame.height * 0.41
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupVCs()
        addMiddleButton()
    }
    
    // MARK: - UIBar Create NavigtaionController
    func setupVCs() {
          viewControllers = [
            createNavController(for: TabbarHomeController.shared, title: NSLocalizedString("홈", comment: ""), image: UIImage(systemName: "house")!),
            createNavController(for: TabbarClipping.shared, title: NSLocalizedString("스크랩보기", comment: ""), image: UIImage(systemName: "newspaper")!),
            createNavController(for: TabbarFeed.shared, title: NSLocalizedString("피드작성", comment: ""), image: UIImage(systemName: "square.and.pencil")!),
            createNavController(for: TabbarSearch.shared, title: NSLocalizedString("검색", comment: ""), image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: TabbarMyInfo.shared, title: NSLocalizedString("마이 써머리", comment: ""), image: UIImage(systemName: "person")!)
          ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String?, image: UIImage) -> UIViewController {
        if rootViewController != TabbarFeed.shared {
            let navController = UINavigationController(rootViewController:  rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
//            navController.isNavigationBarHidden = true
            return navController
        }else {
            return UIViewController()
        }
    }
    
    func addMiddleButton() {
        // DISABLE TABBAR ITEM - behind the "+" custom button:
        DispatchQueue.main.async {
            if let items = self.tabBar.items {
                 items[2].isEnabled = false
            }
        }
        
        // shape, position and size
        tabBar.addSubview(middleButton)
        let size = CGFloat(50)
        
        middleButton.snp.makeConstraints{(make) in
            make.centerX.equalTo(tabBar.snp.centerX)
            make.top.equalTo(tabBar.snp.top).offset(-20)
            make.width.height.equalTo(size)
        }
        
        middleButton.layer.cornerRadius = 15
        
        // shadow
//        middleButton.layer.shadowColor = tColor?.cgColor
//        middleButton.layer.shadowOffset = CGSize(width: 10, height: 10)
//
//        middleButton.layer.shadowOpacity = 1
//        middleButton.layer.shadowRadius = 1
        
        // other
        middleButton.layer.masksToBounds = false
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        
        // action
        middleButton.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
        
    }
    
    @objc func buttonHandler(){
        let wrController = UINavigationController(rootViewController:  WriteFeedController.shared)
        wrController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        wrController.isNavigationBarHidden = true
        self.present(wrController, animated: true, completion: nil)
    }
    
}


