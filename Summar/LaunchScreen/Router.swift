//
//  Router.swift
//  Summar
//
//  Created by mac on 2023/01/10.
//

import Foundation
import UIKit

class Router: UIViewController {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userInfo = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            print(userInfo)
        }else {
            print("UserInfo is nil")
        }
        
        self.navigationController?.pushViewController(SocialLoginController.shared, animated: true)
    }
}
