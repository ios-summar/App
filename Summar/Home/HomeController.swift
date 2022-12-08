//
//  HomeController.swift
//  Summar
//
//  Created by mac on 2022/11/02.
//

import Foundation
import UIKit

class HomeController : UIViewController {
    static let shared = HomeController()

    let homeView = HomeView.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(homeView)
        
        // layout
        homeView.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
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
