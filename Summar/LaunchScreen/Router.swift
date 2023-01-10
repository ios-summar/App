//
//  Router.swift
//  Summar
//
//  Created by mac on 2023/01/10.
//

import Foundation
import UIKit

class Router: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.pushViewController(SocialLoginController.shared, animated: true)
    }
}
