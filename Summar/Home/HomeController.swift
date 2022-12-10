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

    let homeView = HomeView.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(homeView)
        
        UITabBar.appearance().barTintColor = UIColor.summarColor1
        UITabBar.appearance().backgroundColor = UIColor.UIBarColor
        setupVCs()
        
//        homeView.layer.borderColor = UIColor.blue.cgColor
//        homeView.layer.borderWidth = 5
//        homeView.backgroundColor = .grayColor197
        
        // layout
        homeView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.leftMargin.equalTo(0)
            make.rightMargin.equalTo(0)
            make.height.equalTo(50)
        }
        
        
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
        navController.navigationBar.prefersLargeTitles = true
//        rootViewController.navigationItem.title = title
        return navController
    }
    
    // 소셜로그인 로그아웃
    @IBAction func btnAction(_ sender: Any) {
        let objTitle = (sender as? UIButton)?.titleLabel?.text!
        
        switch objTitle {
        case "카카오 로그아웃":
            print("1")
        case "애플계정 로그아웃":
            print("2")
        case "네이버로 로그아웃":
            print("3")
        case "구글 로그아웃":
            print("4")
        default:
            print("default")
        }
    }
}


