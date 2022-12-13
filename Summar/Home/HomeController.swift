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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            print("UserInfo => ", value)
        }else {
            print("userInfo nil")
        }
        
        UITabBar.appearance().barTintColor = UIColor.summarColor1
        UITabBar.appearance().backgroundColor = UIColor.UIBarColor
        setupVCs()
        
    }
    
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
        let navController = UINavigationController(rootViewController:  rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.isNavigationBarHidden = true
        return navController
    }
    
}


